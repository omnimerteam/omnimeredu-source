import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../utils/validator.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../../../../common/widgets/input/primary_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _formAnimationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Lắng nghe sự thay đổi focus
    _emailFocus.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocus.hasFocus;
      });
    });
    _passwordFocus.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocus.hasFocus;
      });
    });

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _formAnimationController.forward();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.error != null && !state.isLogin) {
          context.read<LoginBloc>().add(ClearLoginErrorEvent());
        }

        // Điều hướng đến home khi đăng nhập thành công
        if (state.isLogin && !state.loading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng nhập thành công!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );

          context.read<LoginBloc>().add(ClearLoginErrorEvent());

          // Điều hướng đến home và xóa tất cả route trước đó
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/main', (route) => false);
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _formAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _formAnimationController.value,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      PrimaryTextField(
                        controller: emailCtrl,
                        focusNode: _emailFocus,
                        hintText: "your_email@gmail.com",
                        prefixIcon: Icons.email_outlined,
                        isFocused: _isEmailFocused,
                        validator: (v) =>
                            Validators.requiredField(v, name: "Email") ??
                            Validators.email(v),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 16.h),

                      PrimaryTextField(
                        controller: passCtrl,
                        focusNode: _passwordFocus,
                        hintText: "Mật khẩu",
                        prefixIcon: Icons.lock_outline,
                        isFocused: _isPasswordFocused,
                        obscureText: _obscureText,
                        validator: (v) =>
                            Validators.requiredField(v, name: "Mật khẩu"),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _isPasswordFocused
                                ? AppColors.primary
                                : const Color(0xFF64748B),
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Remember me and Forgot password row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) => setState(
                                    () => _rememberMe = val ?? false,
                                  ),
                                  activeColor: AppColors.primary,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Text(
                                "Nhớ mật khẩu",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF64748B),
                                    ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/forget-password',
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: Text(
                              "Quên mật khẩu?",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // AnimatedSwitcher để lỗi hiện ẩn mượt
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: (state.error != null && !state.isLogin)
                            ? Text(
                                state.error!,
                                key: ValueKey(state.error),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      SizedBox(height: 16.h),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: state.loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email: emailCtrl.text.trim(),
                                        password: passCtrl.text,
                                        rememberMe: _rememberMe,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: AppColors.primary.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            disabledBackgroundColor: const Color(0xFFE2E8F0),
                          ),
                          child: state.loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Đang đăng nhập...",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Đăng nhập",
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        fontFamily: "Inter",
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
