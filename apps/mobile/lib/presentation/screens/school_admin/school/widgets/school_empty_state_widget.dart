import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class SchoolEmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const SchoolEmptyState({Key? key, required this.onCreatePressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.extraLightBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Chưa có thông tin trường',
            style: TextStyle(
              fontSize: 24,
              fontFamily: "PlayfairDisplay",
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tạo thông tin trường để bắt đầu quản lý',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Inter",
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Tạo trường mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
