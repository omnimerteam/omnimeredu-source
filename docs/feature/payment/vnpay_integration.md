# Tích hợp VNPay

## 1. Phương thức tích hợp

Sử dụng phương thức **Web Redirect** (Chuyển hướng sang cổng thanh toán VNPay trên WebView hoặc Trình duyệt).  
*Lý do:* Đây là phương thức chuẩn, ổn định nhất và không phụ thuộc vào SDK của bên thứ 3 (tránh rủi ro outdated).

## 2. Luồng xử lý (Flow)

### Bước 1: Khởi tạo đơn hàng (Backend)

- **App** gửi request: `POST /api/payment/vnpay/create_url` (gồm `amount`, `orderInfo`).
- **Backend**:
  - Tạo URL thanh toán theo chuẩn VNPay (tham số `vnp_Version=2.1.0`, `vnp_Command=pay`, `vnp_TmnCode`, `vnp_ReturnUrl`, chữ ký `vnp_SecureHash` HMAC-SHA512).
  - Trả về: `{ "payment_url": "https://sandbox.vnpayment.vn/..." }`.

### Bước 2: Hiển thị thanh toán (Flutter App)

Sử dụng `url_launcher` để mở trình duyệt hoặc `webview_flutter` để giữ người dùng trong app.

**Khuyên dùng:** `webview_flutter` để UX tốt hơn.

1. Mở WebView với `payment_url` nhận được.
2. Lắng nghe URL thay đổi (NavigationDelegate).
3. Khi URL redirect về `vnp_ReturnUrl` (Ví dụ: `https://omnimer.edu.vn/payment/result`), chặn lại và đóng WebView.
4. Lấy các tham số `vnp_ResponseCode` từ URL để hiển thị kết quả sơ bộ.

### Bước 3: Xác thực giao dịch (Backend IPN)

- VNPay sẽ gọi ngầm vào API IPN của Backend (`vnp_IpnUrl`).
- Backend kiểm tra Checksum, cập nhật trạng thái đơn hàng trong Database → **"Đã thanh toán"**.

## 4. Code Snippet tham khảo (Flutter)

```dart
import 'package:webview_flutter/webview_flutter.dart';

void openVNPay(String paymentUrl) {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://omnimer.edu.vn/payment/result')) {
            // Xử lý kết quả dựa trên params URL
            _handlePaymentResult(Uri.parse(request.url));
            return NavigationDecision.prevent; // Đóng WebView
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(paymentUrl));

  // Hiển thị WebView Widget ở đây (ví dụ: Navigator.push hoặc BottomSheet)
}

void _handlePaymentResult(Uri uri) {
  final responseCode = uri.queryParameters['vnp_ResponseCode'];
  if (responseCode == '00') {
    // Thanh toán thành công
  } else {
    // Thanh toán thất bại / bị hủy
  }
}
