class Validators {
  static String? requiredField(String? v, {String name = 'Trường'}) {
    if (v == null || v.trim().isEmpty) return '$name không được để trống';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email không được để trống';
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!r.hasMatch(v)) return 'Email không hợp lệ';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    return null;
  }
}
