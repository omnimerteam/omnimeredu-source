import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final String label;
  final double size;
  final bool isCircular;

  const ImagePickerWidget({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.label,
    this.size = 120,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircular ? null : BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 2),
              color: AppColors.extraLightBlue.withOpacity(0.3),
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: isCircular
                        ? BorderRadius.circular(size / 2)
                        : BorderRadius.circular(10),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  )
                : Icon(
                    isCircular ? Icons.add_a_photo : Icons.add_photo_alternate,
                    size: size * 0.3,
                    color: AppColors.primary,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
