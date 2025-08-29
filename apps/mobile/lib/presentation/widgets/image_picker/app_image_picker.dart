import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class AppImagePicker extends StatefulWidget {
  final String label;
  final void Function(File? file) onPicked;

  const AppImagePicker({
    super.key,
    required this.label,
    required this.onPicked,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  File? _file;
  final _picker = ImagePicker();

  Future<void> _pick() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() => _file = x != null ? File(x.path) : null);
    widget.onPicked(_file);
  }

  @override
  Widget build(BuildContext context) {
    return GFCard(
      color: AppColors.lightBlue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      content: InkWell(
        onTap: _pick,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.lightBlue,
              backgroundImage: _file != null ? FileImage(_file!) : null,
              child: _file == null
                  ? const Icon(
                      Icons.add_a_photo,
                      color: AppColors.primary,
                      size: 32,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
