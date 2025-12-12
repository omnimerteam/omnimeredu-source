import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? avatarUrl;
  final VoidCallback onTap;
  final String label;
  final double size;
  final bool isCircular;
  final bool isUploading;
  final bool isDark;

  const ImagePickerWidget({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.label,
    this.avatarUrl,
    this.size = 120,
    this.isCircular = true,
    this.isUploading = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isCircular
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(12.r);

    final theme = Theme.of(context);

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
        color: theme.colorScheme.primary,
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
                width: size.w,
                height: size
                    .w, // Ensure square feeling with width ratio or height ratio? Square usually w=h
                decoration: BoxDecoration(
                  shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isCircular ? null : borderRadius,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2.w,
                  ),
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
        SizedBox(height: 8.h),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
