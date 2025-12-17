class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Trường này là bắt buộc';
    }
    return null;
  }
}
