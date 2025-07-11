import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscure;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFTextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white, // Nền trắng
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Bo góc 20%
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Giữ bo góc khi focus
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
