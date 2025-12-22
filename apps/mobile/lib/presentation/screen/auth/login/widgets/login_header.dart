import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({super.key});

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated logo container
        Stack(
          alignment: Alignment.center,
          children: [
            // Logo trung tâm
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, Color(0xFF6366F1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo/Pictorial_mark_logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Bong bóng xung quanh
            ...[
              {
                'icon': Icons.calendar_today,
                'angle': -pi / 4,
                'color': Colors.orange,
              },
              {'icon': Icons.school, 'angle': pi / 4, 'color': Colors.green},
              {
                'icon': Icons.payment,
                'angle': 3 * pi / 4,
                'color': AppColors.blue,
              },
              {
                'icon': Icons.check_circle,
                'angle': -3 * pi / 4,
                'color': Colors.purple,
              },
            ].map((item) {
              final radius = 100.0.w; // khoảng cách từ logo trung tâm
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final offsetX = radius * cos(item['angle'] as double);
                  final offsetY = radius * sin(item['angle'] as double);
                  return Transform.translate(
                    offset: Offset(offsetX, offsetY),
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['color'] as Color,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),

        SizedBox(height: 24.h),

        // Animated title and subtitle
        FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Text(
                "OmniMer EDU",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: "PlayfairDisplay",
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
                  letterSpacing: 0.5.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Quản lý trường học thông minh",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
