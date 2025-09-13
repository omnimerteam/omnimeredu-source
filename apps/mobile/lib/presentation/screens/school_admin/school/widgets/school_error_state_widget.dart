import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class SchoolErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetryPressed;

  const SchoolErrorState({
    Key? key,
    required this.message,
    required this.onRetryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(Icons.error_outline, size: 60, color: AppColors.error),
          ),
          const SizedBox(height: 24),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Inter",
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onRetryPressed,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.backgroundLight,
              size: 20,
            ),
            label: const Text(
              'Thử lại',
              style: TextStyle(
                color: AppColors.backgroundLight,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
