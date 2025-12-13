import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class LoginFooter extends StatefulWidget {
  const LoginFooter({super.key});

  @override
  State<LoginFooter> createState() => _LoginFooterState();
}

class _LoginFooterState extends State<LoginFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Delay the animation slightly
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Divider with text
          Row(
            children: [
              const Expanded(
                child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  "hoặc",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Social login buttons
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  icon: Icons.g_mobiledata,
                  label: "Google",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đăng nhập bằng Google - Sắp ra mắt'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSocialButton(
                  icon: Icons.facebook,
                  label: "Facebook",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đăng nhập bằng Facebook - Sắp ra mắt'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Sign up prompt
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chưa có tài khoản? ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/register");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Tạo ngay",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Terms and privacy
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                "Bằng việc đăng nhập, bạn đồng ý với ",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Điều khoản dịch vụ",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                " và ",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontFamily: "Inter",
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Chính sách bảo mật",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20.sp, color: const Color(0xFF64748B)),
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF374151),
        ),
      ),
    );
  }
}
