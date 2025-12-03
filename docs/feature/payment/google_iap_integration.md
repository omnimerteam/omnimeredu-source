# Tích hợp Google Play Billing

```markdown
# Hướng dẫn Tích hợp Google Play Billing (In-App Purchase)

**Package sử dụng:** `in_app_purchase` (Official Flutter Team).
**Phiên bản khuyến nghị:** `^3.2.0` (Tính đến 12/2025).

## 1. Quy trình chuẩn bị
1.  **Google Play Console:** Tạo sản phẩm (Product ID) dạng `Subscription` (Gói VIP) hoặc `Consumable` (Coin).
2.  **Active:** Sản phẩm phải ở trạng thái "Active".
3.  **Tester:** Thêm email tester vào danh sách License Testing để test thẻ Visa giả mà không bị trừ tiền thật.

## 2. Luồng Code (Client-Side)

### A. Khởi tạo & Lắng nghe
Việc lắng nghe stream thanh toán phải được thực hiện ngay khi App khởi động (`main.dart` hoặc `AppInit`).

```dart
final InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<List<PurchaseDetails>> _subscription;

void initState() {
  final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
  _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    _listenToPurchaseUpdated(purchaseDetailsList);
  }, onDone: () {
    _subscription.cancel();
  }, onError: (error) {
    // Handle error
  });
}

B. Xử lý giao dịch (_listenToPurchaseUpdated)
   Các trạng thái quan trọng: pending (đang chờ), purchased (thành công), error (lỗi).

QUAN TRỌNG:
- Server Verification: Khi nhận được purchased, KHÔNG tin tưởng ngay. Gửi purchaseDetails.verificationData (gồm serverVerificationData / purchaseToken) về Backend OmniMer.
- Complete Purchase: Sau khi Backend xác thực thành công (trả về OK), App bắt buộc phải gọi _inAppPurchase.completePurchase(purchaseDetails). Nếu không, Google sẽ hoàn tiền sau 3 ngày.

void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
  for (var purchaseDetails in purchaseDetailsList) {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // Show loading UI
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        
        // Gửi token về Backend để verify
        bool valid = await BackendAPI.verifyReceipt(purchaseDetails.verificationData);
        
        if (valid) {
          // Verify OK -> Đánh dấu hoàn tất giao dịch với Google
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          // Unlock tính năng VIP cho User
        }
      }
    }
  }
}

3. Lưu ý đặc biệt
- iOS: Cần thêm cấu hình trong Xcode Capabilities -> In-App Purchase.
- Backend Verify: Backend cần dùng Service Account Google để gọi Google Play Developer API xác thực purchaseToken. Đây là bước bắt buộc để chống hack/giả mạo receipt.
