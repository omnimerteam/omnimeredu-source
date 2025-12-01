# DEPLOY_IOS.md – OmniMer EDU

## Mục tiêu

Deploy ứng dụng iOS của OmniMer EDU lên **Apple App Store** để người dùng có thể tải về từ iPhone/iPad.

---

## 1. Yêu cầu chuẩn bị

| Thành phần                        | Ghi chú |
|----------------------------------|--------|
| MacBook hoặc máy ảo macOS        | Bắt buộc để build iOS app |
| Apple Developer Program          | $99/năm – đăng ký tại https://developer.apple.com |
| App được phát triển bằng Flutter / React Native / Swift | Project đã sẵn sàng |
| App icon, mô tả, ảnh chụp màn hình | Dùng trong App Store Connect |
| Xcode (phiên bản mới nhất)       | Cài từ Mac App Store |
| File Provisioning Profile & Certificate | Cấu hình trong Apple Developer Portal |

---

## 2. Đăng ký tài khoản & cấu hình môi trường

### Bước 1: Đăng ký Apple Developer Program

- Truy cập: https://developer.apple.com/programs/
- Đăng nhập bằng Apple ID
- Thanh toán $99/năm

---

### Bước 2: Cài đặt Xcode

- Mở **Mac App Store** → tìm **Xcode** → bấm "Install"

---

### Bước 3: Cấu hình App ID và Provisioning Profiles
   - **iOS Distribution Certificate**
   - **Provisioning Profile** cho app

Ghi chú: Bundle ID phải khớp với project (ví dụ: `com.omnimer.edu`)

---

## 3. Build và ký ứng dụng iOS

### Nếu dùng **Flutter**:

```bash
flutter build ios --release
open ios/Runner.xcworkspace
```

## 4. Deploy lên App Store

### Bước 1: Tạo app trong App Store Connect

- Truy cập: https://appstoreconnect.apple.com
- Chọn My Apps > +      
- Nhập thông tin:
    . Tên app: OmniMer EDU
    . Platform: iOS
    . Bundle ID: Trùng với project
    . Ngôn ngữ chính: English / Vietnamese
    . SKU: omnimer-ios

### Bước 2: Upload ứng dụng từ XCode

- Trong Xcode: Product → Archive
- Sau khi archive xong → Chọn Distribute App
- Chọn:
    . Method: App Store Connect
    . Destination: Upload
- Sau khi upload xong → quay lại App Store Connect

### Bước 3: Cấu hình mô tả và metadata

- Cung cấp các thông tin:
    . App icon: PNG 1024x1024
    . Screenshots: cho iPhone 6.5", 5.5", iPad (tối thiểu 1 ảnh/mỗi thiết bị)
    . Short description (30–80 ký tự)
    . Full description: mô tả app chi tiết
    . Privacy Policy URL
    . App Privacy: khai báo quyền dữ liệu
    . App Review Notes: thêm thông tin cho reviewer nếu 
    
### Bước 4: Gửi duyệt ứng dụng

- Chọn bản build vừa upload
- Nhấn Submit for Review
- Đợi Apple xét duyệt

### Thời gian xét duyệt

- App phát hành lần đầu: 2-5 ngày
- App cập nhật: 1-3 ngày

