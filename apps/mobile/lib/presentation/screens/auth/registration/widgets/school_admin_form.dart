import 'package:flutter/material.dart';
import '../../../../widgets/text_field/primary_text_field.dart';

class SchoolAdminForm extends StatefulWidget {
  const SchoolAdminForm({super.key});

  @override
  State<SchoolAdminForm> createState() => _SchoolAdminFormState();
}

class _SchoolAdminFormState extends State<SchoolAdminForm> {
  final schoolNameCtrl = TextEditingController();
  final schoolCodeCtrl = TextEditingController();
  final positionCtrl = TextEditingController();

  String? schoolOption; // new | join

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: const Text("Tạo trường mới"),
          value: "new",
          groupValue: schoolOption,
          onChanged: (val) => setState(() => schoolOption = val.toString()),
        ),
        RadioListTile(
          title: const Text("Tham gia trường có sẵn"),
          value: "join",
          groupValue: schoolOption,
          onChanged: (val) => setState(() => schoolOption = val.toString()),
        ),
        if (schoolOption == "new")
          PrimaryTextField(
            controller: schoolNameCtrl,
            focusNode: FocusNode(),
            hintText: "Tên trường",
            prefixIcon: Icons.school,
            isFocused: false,
          ),
        if (schoolOption == "join") ...[
          PrimaryTextField(
            controller: schoolCodeCtrl,
            focusNode: FocusNode(),
            hintText: "Mã hoặc tên trường",
            prefixIcon: Icons.search,
            isFocused: false,
          ),
          const SizedBox(height: 12),
          PrimaryTextField(
            controller: positionCtrl,
            focusNode: FocusNode(),
            hintText: "Vị trí ứng tuyển",
            prefixIcon: Icons.work,
            isFocused: false,
          ),
        ],
      ],
    );
  }
}
