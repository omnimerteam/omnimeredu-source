import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? avatarUrl;
  final VoidCallback onTap;
  final String label;
  final double size;
  final bool isCircular;
  final bool isUploading;

  const ImagePickerWidget({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.label,
    this.avatarUrl,
    this.size = 120,
    this.isCircular = true,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isCircular
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(12);

    Widget imageContent;

    if (imageFile != null) {
      // Ảnh mới được chọn
      imageContent = Image.file(imageFile!, fit: BoxFit.cover);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      // Ảnh từ server
      imageContent = Image.network(avatarUrl!, fit: BoxFit.cover);
    } else {
      // Icon mặc định
      imageContent = Icon(
        isCircular ? Icons.add_a_photo : Icons.add_photo_alternate,
        size: size * 0.3,
        color: AppColors.primary,
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isCircular ? null : BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: AppColors.extraLightBlue.withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: imageContent,
                ),
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: isCircular ? null : borderRadius,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
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
