import 'package:flutter/material.dart';
import '../../../../widgets/text_field/primary_text_field.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final schoolCodeCtrl = TextEditingController();
  final classCodeCtrl = TextEditingController();
  final guardianCtrl = TextEditingController();
  final guardianPhoneCtrl = TextEditingController();
  final gradeCtrl = TextEditingController();

  String? educationLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryTextField(
          controller: schoolCodeCtrl,
          focusNode: FocusNode(),
          hintText: "Mã trường",
          prefixIcon: Icons.school,
          isFocused: false,
        ),
        const SizedBox(height: 12),
        PrimaryTextField(
          controller: classCodeCtrl,
          focusNode: FocusNode(),
          hintText: "Mã lớp học",
          prefixIcon: Icons.class_,
          isFocused: false,
        ),
        const SizedBox(height: 12),
        PrimaryTextField(
          controller: guardianCtrl,
          focusNode: FocusNode(),
          hintText: "Tên phụ huynh",
          prefixIcon: Icons.family_restroom,
          isFocused: false,
        ),
        const SizedBox(height: 12),
        PrimaryTextField(
          controller: guardianPhoneCtrl,
          focusNode: FocusNode(),
          hintText: "SĐT phụ huynh",
          prefixIcon: Icons.phone,
          isFocused: false,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: educationLevel,
          decoration: const InputDecoration(labelText: "Trình độ học vấn"),
          items: const [
            DropdownMenuItem(value: "Preschool", child: Text("Mầm non")),
            DropdownMenuItem(value: "Primary", child: Text("Tiểu học")),
            DropdownMenuItem(value: "Secondary", child: Text("THCS")),
            DropdownMenuItem(value: "HighSchool", child: Text("THPT")),
          ],
          onChanged: (val) => setState(() => educationLevel = val),
        ),
        const SizedBox(height: 12),
        PrimaryTextField(
          controller: gradeCtrl,
          focusNode: FocusNode(),
          hintText: "Khối lớp (VD: 10A1)",
          prefixIcon: Icons.grade,
          isFocused: false,
        ),
      ],
    );
  }
}
