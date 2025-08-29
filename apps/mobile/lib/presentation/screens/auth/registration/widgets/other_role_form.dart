import 'package:flutter/material.dart';
import '../../../../widgets/text_field/primary_text_field.dart';

class OtherRoleForm extends StatelessWidget {
  OtherRoleForm({super.key});

  final schoolNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: schoolNameCtrl,
      focusNode: FocusNode(),
      hintText: "Tên trường muốn ứng tuyển",
      prefixIcon: Icons.school,
      isFocused: false,
    );
  }
}
