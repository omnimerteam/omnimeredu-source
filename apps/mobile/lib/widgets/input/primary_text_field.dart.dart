import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscure;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text, // Thêm mặc định
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFTextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType, // Bổ sung để hiện đúng bàn phím
      readOnly: false, // Đảm bảo có thể focus và gõ
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
