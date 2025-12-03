# Chiến Lược Tích Hợp Thanh Toán - OmniMer EDU

## 1. Tổng quan phương thức

Dựa trên đặc thù người dùng Việt Nam và chính sách của Apple/Google, hệ thống sẽ triển khai song song 3 phương thức:

| Phương thức              | Ưu tiên   | Mục đích sử dụng                  | Công nghệ lõi (Flutter)                  | Ghi chú                                      |
|--------------------------|-----------|-----------------------------------|------------------------------------------|----------------------------------------------|
| **Cổng thanh toán (VNPay)**     | **Hạng 1** | Thu học phí, phí dịch vụ lớn      | `webview_flutter` hoặc `url_launcher` (Web Redirect) | Phí thấp (~1-2%), Hợp pháp cho giáo dục.    |
| **Ví điện tử (MoMo/ZaloPay)**   | **Hạng 2** | Thanh toán nhanh, học phí nhỏ     | Deep Link (App-to-App)                   | Phổ biến với học sinh/sinh viên.            |
| **Google Play Billing**         | **Hạng 3** | Gói VIP, Coin, Item số            | `in_app_purchase` (Official)             | Bắt buộc cho hàng hóa số (Digital Goods). Phí cao (15-30%). |

## 2. Nguyên tắc bảo mật chung

Để đảm bảo an toàn tài chính và tránh lộ Secret Key, **tất cả** các giao dịch đều tuân thủ nguyên tắc "Server-Side Initiation":

* Không lưu Secret Key dưới App: App không được phép thực hiện việc tạo chữ ký (hashing) hay gọi trực tiếp API tạo đơn hàng của đối tác.
* Luồng dữ liệu:
  * **Bước 1:** App gọi Backend OmniMer API để yêu cầu thanh toán.
  * **Bước 2:** Backend gọi API đối tác (VNPay/MoMo) → Nhận về `Payment URL` hoặc `DeepLink`.
  * **Bước 3:** App mở URL/DeepLink để người dùng thanh toán.
  * **Bước 4:** Kết quả thanh toán được đối tác bắn về Backend (IPN/Callback).
  * **Bước 5:** App nhận thông báo từ Backend (qua Socket/FCM) hoặc chủ động query trạng thái đơn hàng.

## 3. Cấu trúc thư mục Feature

Các tài liệu chi tiết kỹ thuật được chia tách như sau:

* `vnpay_integration.md`: Chi tiết luồng VNPay.
* `momo_integration.md`: Chi tiết luồng Ví điện tử.
* `google_iap_integration.md`: Chi tiết luồng In-App Purchase.
