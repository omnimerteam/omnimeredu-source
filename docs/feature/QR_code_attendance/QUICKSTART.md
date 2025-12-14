# ⚡ Quick Start - QR Code Attendance

## 🚀 Setup nhanh trong 5 phút

### 1️⃣ Install Dependencies (1 phút)

```bash
cd apps/omnimereduapp
flutter pub get
```

### 2️⃣ Generate Code (1 phút)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3️⃣ Configure Permissions (2 phút)

#### Android: `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

#### iOS: `ios/Runner/Info.plist`
```xml
<key>NSCameraUsageDescription</key>
<string>Cần camera để quét QR</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cần vị trí để xác nhận điểm danh</string>
```

### 4️⃣ Use in Code (1 phút)

#### Teacher - Show QR:
```dart
import 'presentation/screens/qr_attendance/teacher/qr_display_screen.dart';

Navigator.push(context, MaterialPageRoute(
  builder: (_) => QRDisplayScreen(
    attendanceId: 'abc123',
    className: '10A1',
    subject: 'Toán',
    date: DateTime.now(),
  ),
));
```

#### Student - Scan QR:
```dart
import 'presentation/screens/qr_attendance/student/qr_scanner_screen.dart';

Navigator.push(context, MaterialPageRoute(
  builder: (_) => QRScannerScreen(),
));
```

### 5️⃣ Test! (1 phút)

```bash
flutter run
```

---

## 📋 Checklist

- [ ] `flutter pub get` done
- [ ] `build_runner` done  
- [ ] Android permissions added
- [ ] iOS permissions added
- [ ] Test on real device

---

## 🆘 Quick Fixes

**Build error?**
```bash
flutter clean
flutter pub get
```

**Permission denied?**
- Check AndroidManifest.xml / Info.plist
- Test on real device (not emulator)

**Camera not working?**
- Use real device
- Grant camera permission in settings

---

## 📚 Full Docs

- 📖 [IMPLEMENTATION.md](./IMPLEMENTATION.md) - Chi tiết implementation
- 🔐 [PERMISSIONS.md](./PERMISSIONS.md) - Cấu hình permissions
- 📊 [SUMMARY.md](./SUMMARY.md) - Tổng quan toàn bộ

---

**Ready in 5 minutes! 🎉**

