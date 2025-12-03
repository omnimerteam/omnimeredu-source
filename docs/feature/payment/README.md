# Tài liệu Tích hợp Thanh toán (Payment Integration)

Tài liệu này tổng hợp chiến lược và hướng dẫn kỹ thuật cho việc tích hợp các cổng thanh toán vào ứng dụng OmniMer EDU.

## 1. Tổng quan Chiến lược (Payment Strategy)

Hệ thống hỗ trợ đa dạng phương thức thanh toán để phù hợp với thói quen người dùng và quy định của Store:

| Phương thức             | Ưu tiên | Mục đích                     | Công nghệ                        |
| :---------------------- | :------ | :--------------------------- | :------------------------------- |
| **VNPay**               | Hạng 1  | Thu học phí, giao dịch lớn   | Web Redirect (`webview_flutter`) |
| **MoMo/ZaloPay**        | Hạng 2  | Thanh toán nhanh, nhỏ lẻ     | App-to-App Deep Link             |
| **Google Play Billing** | Hạng 3  | Mua Coin, VIP, Digital Goods | In-App Purchase SDK              |

**Nguyên tắc cốt lõi:** **Server-Side Initiation**.

- Không lưu Secret Key dưới Client (App).
- Mọi giao dịch bắt đầu từ Backend gọi sang đối tác.
- Kết quả cuối cùng dựa trên IPN/Callback từ đối tác gửi về Backend.

📄 **Chi tiết:** [Chiến lược Tích hợp Thanh toán](./payment_strategy_overview.md)

---

## 2. Mục lục Chi tiết

Dưới đây là các tài liệu hướng dẫn kỹ thuật chi tiết cho từng phương thức:

### 🔹 [Tích hợp VNPay](./vnpay_integration.md)

- **Phương thức:** Web Redirect.
- **Luồng chính:** Backend tạo URL thanh toán -> App mở WebView -> Người dùng thanh toán -> Redirect về App -> Backend nhận IPN xác thực.
- **Lưu ý:** Sử dụng `webview_flutter` để chặn URL redirect và xử lý kết quả UX mượt mà.

### 🔹 [Tích hợp MoMo](./momo_integration.md)

- **Phương thức:** App-to-App (Deep Link).
- **Luồng chính:** Backend lấy Deep Link từ MoMo -> App mở Deep Link qua App MoMo -> Thanh toán xong MoMo gọi lại App qua Scheme `omnimer://`.
- **Cấu hình:** Cần setup `AndroidManifest.xml` và `Info.plist` để nhận Deep Link.
- **Thư viện:** `app_links`.

### 🔹 [Tích hợp Google Play Billing (IAP)](./google_iap_integration.md)

- **Phương thức:** Native In-App Purchase.
- **Luồng chính:** App khởi tạo giao dịch với Google -> Nhận `purchaseToken` -> Gửi về Backend -> Backend gọi Google API để Verify -> App hoàn tất (`completePurchase`).
- **Quan trọng:** Bắt buộc verify receipt tại Backend để tránh gian lận. Nếu không `completePurchase` trong 3 ngày, Google sẽ hoàn tiền.

---

## 3. Yêu cầu chung cho Backend API

Để hỗ trợ các phương thức trên, Backend cần cung cấp các nhóm API sau:

1.  **Payment Request:**
    - `POST /api/payment/vnpay/create`
    - `POST /api/payment/momo/create`
2.  **Verification (IAP):**
    - `POST /api/payment/iap/verify`
3.  **IPN/Callback (Public webhook):**
    - `GET/POST /api/payment/vnpay/ipn`
    - `POST /api/payment/momo/ipn`
