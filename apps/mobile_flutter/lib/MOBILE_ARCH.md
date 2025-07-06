lib/
├── main.dart
├── core/ # Thành phần dùng chung: theme, constants, utils
├── config/ # Config env, routes
├── models/ # Định nghĩa data models (User, Fee, Attendance)
├── services/ # Gọi API, Firebase, local storage
├── providers/ # State management (Riverpod, Provider, Bloc)
├── screens/ # UI chia theo tính năng
│ ├── auth/
│ ├── attendance/
│ ├── fee/
│ └── dashboard/
├── widgets/ # Widget tái sử dụng (custom button, textfield)
├── l10n/ # File đa ngôn ngữ (nếu có)
└── assets/ # Ảnh, icon, font
