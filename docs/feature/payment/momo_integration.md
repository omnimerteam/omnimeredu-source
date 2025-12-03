# Tích hợp MoMo

## 1. Phương thức tích hợp

Sử dụng phương thức **App-to-App (Deep Link)**.  
Cơ chế: Từ App OmniMer mở App MoMo để thanh toán → MoMo tự động quay lại App OmniMer với kết quả.

## 2. Cấu hình Platform

### 2.1 Android (AndroidManifest.xml)

Cần cấu hình `intent-filter` để App nhận callback từ MoMo:

```xml
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="omnimer" android:host="payment" />
    </intent-filter>
</activity>

2.2 iOS (Info.plist)
Thêm URL Scheme để nhận callback từ MoMo:
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>momo</string> </array>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>vn.edu.omnimer</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>omnimer</string>
    </array>
  </dict>
</array>

3. Luồng xử lý (Server-Side Initiation)
    1. App yêu cầu tạo đơn (Backend), 
        - Gọi API MoMo (AIO Payment), tham số redirectUrl = omnimer://payment/momo_callback.
        - Gọi POST /api/payment/momo/create với amount, orderInfo, returnUrl = omnimer://payment.
    2. Backend trả về Deep Link MoMo
        - Trả về cho Web: Gọi API MoMo → nhận payUrl (ví dụ: momo://app...?partnerCode=...&signature=...).
        - Trả về cho App: { "deeplink": "momo://app..." }.

    3. App mở Deep Link
      - Kiểm tra nếu có cài app MoMo: Dùng url_launcher gọi launchUrl(Uri.parse(deeplink), mode: 
      - LaunchMode.externalApplication).
        Nếu không cài: Mở payUrl bằng WebView.

    4. MoMo trả kết quả về App
      - Sử dụng package app_links hoặc uni_links để lắng nghe khi App được mở lại từ MoMo.
      omnimer://payment?resultCode=0&... → parse query params → hiển thị kết quả sơ bộ.

      // Ví dụ lắng nghe Deep Link trả về
      final _appLinks = AppLinks(); // Package: app_links (Mới nhất, thay thế uni_links)
      void initDeepLinkListener() {
        _appLinks.uriLinkStream.listen((Uri? uri) {
          if (uri != null && uri.scheme == 'omnimer' && uri.path.contains('momo_callback')) {
              // Gọi API Backend kiểm tra lại trạng thái đơn hàng lần cuối
              checkOrderStatus();
          }
        });
      }

    5. Backend nhận IPN (bắt buộc)
    MoMo vẫn gửi IPN về server → Backend kiểm tra chữ ký và cập nhật trạng thái đơn hàng chính thức.

4. Code mẫu lắng nghe callback (Flutter)

  import 'package:app_links/app_links.dart';

  final _appLinks = AppLinks();

  void initMoMoCallback() async {
    // Lắng nghe khi người dùng quay lại từ MoMo
    _appLinks.uriLinkStream.listen((uri) {
      if (uri?.scheme == 'omnimer' && uri?.host == 'payment') {
        final resultCode = uri?.queryParameters['resultCode'];
        if (resultCode == '0') {
          // Thanh toán thành công (chỉ là UX, chưa chính thức)
          print('MoMo: Thanh toán thành công');
        } else {
          // Thanh toán thất bại / bị hủy
          print('MoMo: Thanh toán thất bại - $resultCode');
        }
      }
    });
  }

Lưu ý quan trọng:

    - Kết quả từ Deep Link chỉ dùng để cải thiện UX.
    - Luôn phải chờ IPN từ Backend để xác nhận thanh toán chính thức (tránh fake callback).
    - Không bao giờ lưu Secret Key hoặc Access Key của MoMo trên ứng dụng Flutter.
