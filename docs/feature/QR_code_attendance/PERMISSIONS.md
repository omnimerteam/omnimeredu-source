# QR Code Attendance - Permissions Configuration Guide

## 📱 Android Configuration

### 1. Update `android/app/src/main/AndroidManifest.xml`

Add these permissions before the `<application>` tag:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Internet permission for API calls -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <!-- Camera permission for QR scanning -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature 
        android:name="android.hardware.camera" 
        android:required="false"/>
    <uses-feature 
        android:name="android.hardware.camera.autofocus" 
        android:required="false"/>
    
    <!-- Location permissions for geo-fencing -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <!-- Foreground service for background sync (optional) -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    
    <application
        ...>
        ...
    </application>
</manifest>
```

### 2. Minimum SDK Version

Update `android/app/build.gradle.kts`:

```kotlin
android {
    defaultConfig {
        minSdk = 21  // Required for mobile_scanner
        targetSdk = 34
    }
}
```

---

## 🍎 iOS Configuration

### 1. Update `ios/Runner/Info.plist`

Add these keys:

```xml
<dict>
    ...
    
    <!-- Camera Usage -->
    <key>NSCameraUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập camera để quét mã QR điểm danh</string>
    
    <!-- Location Usage -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập vị trí để xác nhận bạn đang ở trong lớp học khi điểm danh</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập vị trí để tự động đồng bộ điểm danh khi bạn quay lại trường</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập vị trí để điểm danh và tự động đồng bộ dữ liệu</string>
    
    <!-- Background modes (optional for auto-sync) -->
    <key>UIBackgroundModes</key>
    <array>
        <string>location</string>
        <string>fetch</string>
    </array>
    
    ...
</dict>
```

### 2. Minimum iOS Version

Update `ios/Podfile`:

```ruby
platform :ios, '12.0'  # Required for mobile_scanner
```

---

## ✅ Runtime Permission Handling

Permissions are automatically requested by the services when needed:

### Camera Permission
- Requested when opening `QRScannerScreen`
- Handled by `mobile_scanner` package

### Location Permission
- Requested by `LocationService` when first needed
- Custom exceptions provided:
  - `LocationServiceDisabledException`
  - `LocationPermissionDeniedException`
  - `LocationPermissionDeniedForeverException`

---

## 🧪 Testing Permissions

### Android Testing

```bash
# Grant permissions via ADB
adb shell pm grant com.your.package android.permission.CAMERA
adb shell pm grant com.your.package android.permission.ACCESS_FINE_LOCATION
adb shell pm grant com.your.package android.permission.ACCESS_COARSE_LOCATION

# Revoke permissions to test denial
adb shell pm revoke com.your.package android.permission.CAMERA
```

### iOS Testing

- Test on real device (Simulator has limited location support)
- Go to Settings → Privacy → Camera/Location to manage permissions
- Test "Allow While Using App" and "Allow Always" options

---

## 🚨 Common Issues

### Issue: Camera not working on Android
**Solution:** 
- Ensure `minSdk >= 21`
- Test on real device (emulator camera support is limited)
- Check if camera permission is granted

### Issue: Location always returns "denied"
**Solution:**
- Check if GPS is enabled in device settings
- Verify permissions in AndroidManifest.xml / Info.plist
- Request location permission explicitly before scanning

### Issue: iOS build fails
**Solution:**
- Run `cd ios && pod install`
- Clean build folder: `flutter clean && flutter pub get`

---

## 📋 Checklist Before Release

- [ ] Camera permission added to AndroidManifest.xml
- [ ] Camera permission added to Info.plist
- [ ] Location permissions added to both platforms
- [ ] Usage descriptions are user-friendly and in Vietnamese
- [ ] Minimum SDK/iOS version updated
- [ ] Test on real Android device
- [ ] Test on real iOS device
- [ ] Test permission denial scenarios
- [ ] Test permission "denied forever" scenario
- [ ] Test offline mode
- [ ] Test location accuracy

---

## 📚 References

- [mobile_scanner documentation](https://pub.dev/packages/mobile_scanner)
- [geolocator documentation](https://pub.dev/packages/geolocator)
- [Android permissions guide](https://developer.android.com/guide/topics/permissions/overview)
- [iOS permissions guide](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy)

