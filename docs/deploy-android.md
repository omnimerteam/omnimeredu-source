# DEPLOY_ANDROID.md - OmniMer EDU

## Mục tiêu

Deploy ứng dụng Android của OmniMer EDU lên Google Play Store để người dùng có thể cài đặt từ CH Play.

---

## 1. Yêu cầu chuẩn bị

| Thành phần           | Ghi chú |
|----------------------|--------|
| Tài khoản Google Play Developer | Đăng ký tại https://play.google.com/console ($25 – phí 1 lần duy nhất) |
| File `.aab` (Android App Bundle) | Build từ Android Studio |
| Release key (.jks)   | Để ký ứng dụng trước khi publish |
| Thông tin ứng dụng   | Tên app, mô tả, icon, ảnh màn hình... |
| Chính sách bảo mật   | URL dẫn đến trang Privacy Policy (dùng GitHub Pages, Firebase Hosting hoặc bất kỳ trang web nào) |

---

## 2. Build và ký ứng dụng


### Bước 1: Tạo Keystore (chỉ tạo 1 lần)

```bash
keytool -genkey -v -keystore omnimer-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias omnimer 
```
### Bước 2: Cấu hình signing trong build.gradle

"android {
    signingConfigs {
        release {
            storeFile file("omnimer-release-key.jks")
            storePassword "your-password"
            keyAlias "omnimer"
            keyPassword "your-password"
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
        }
    }
}"

### Bước 3: Build file .aab 

- File .aab (Android app Bundle) là định dạnh build chính thức do google phát triển để phát hành ứng dụng Android lên Google Play Store.
- Lệnh "./gradlew bundleRelease"
- File .aab sẽ nằm tại: app/build/outputs/bundle/release/app-release.aab

### Bước 4: Deploy lên Google Play Console

- Bước 1: Tạo ứng dụng mới
    1. Truy cập: https://play.google.com/console
    2. Chọn “Create app”
    3. Điền:
        . Tên app: OmniMer EDU
        . Ngôn ngữ: English / Vietnamese
        . App type: App
        . Free / Paid: Chọn “Free”
        . Tích vào các chính sách → bấm “Create”

- Bước 2: Cấu hình nội dung ứng dụng
    1. Điền các mục:
        . Short Description: 80 ký tự (hiện trên tìm kiếm)
        . Full Description: Mô tả chi tiết app
        . App icon: PNG 512x512
        . Screenshots: Ít nhất 2 ảnh từ thiết bị thật (độ phân giải tối thiểu 320px)
        . Feature Graphic (tuỳ chọn): 1024x500
        . Privacy Policy: URL dẫn đến trang chính sách bảo mật

- Bước 3: Upload file .aab
    1. Vào "Release > Production > Create new release"
    2. Upload file .aab
    3. Chọn “Google Play App Signing” (Google sẽ bảo vệ key giúp bạn)
    4. Nhấn Save

- Bước 4: Gửi duyệt ứng dụng
    1. Quay lại Dashboard
    2. Đảm bảo các mục:
        . App Content (phân loại độ tuổi, quyền truy cập...)
        . Target Audience
        . Ads status (có/không chạy quảng cáo)
        . Data safety
    3. Sau khi hoàn tất, nhấn “Review and Rollout to Production”
    4. Nhấn “Start rollout to production”

### Thời gian xét duyệt:    
- App lần đầu: 3 - 7 ngày
- App update: 1 - 3 ngày


## 3. Build ứng dụng lên VPS .APK

### Flow deploy ứng dụng lên VPS

    1. Developer push code Flutter (main)
            ↓
    2. GitHub Actions build file .apk
            ↓
    3. Tự động upload file .apk lên VPS
            ↓
    4. User truy cập đường link VPS để tải app về
            ↓
    5. Cài đặt và sử dụng app, kết nối tới backend trên VPS


### Ứng dụng sẽ được lưu trữ /var/www/flutter/app

