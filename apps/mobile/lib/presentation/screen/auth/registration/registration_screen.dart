import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_event.dart';
import 'bloc/registration_state.dart';
import 'widgets/already_have_account.dart';
import 'widgets/step_basic_info.dart';
import 'widgets/step_review.dart';
import 'widgets/step_role.dart';
import '../../../widgets/button/register_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentPage = 0;
  final int totalPages = 3;

  @override
  void initState() {
    super.initState();
    context.read<RegistrationBloc>().add(LoadRolesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegistrationBloc>().add(SubmitRegistrationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        title: const Text(
          'Đăng ký tài khoản',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.error != null) {
            // Hiển thị lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state.success) {
            // Nếu đăng ký thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công!'),
                backgroundColor: Colors.green,
              ),
            );

            context.read<RegistrationBloc>().add(ResetRegistration());

            // Điều hướng về màn hình login
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Progress bar
              Container(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: List.generate(totalPages, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < totalPages - 1 ? 8.w : 0,
                        ),
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: index <= currentPage
                              ? AppColors.primary
                              : AppColors.extraLightBlue,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // PageView steps
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (p) => setState(() => currentPage = p),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StepBasicInfo(state: state),
                      StepRole(state: state),
                      StepReview(state: state),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Container(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    if (currentPage > 0)
                      Expanded(
                        child: RegisterButton(
                          text: 'Quay lại',
                          onPressed: _previousPage,
                          isOutlined: true,
                        ),
                      ),
                    if (currentPage > 0) SizedBox(width: 16.w),
                    Expanded(
                      child: RegisterButton(
                        text: currentPage == totalPages - 1
                            ? 'Đăng ký'
                            : 'Tiếp tục',
                        onPressed: currentPage == totalPages - 1
                            ? _submitRegistration
                            : _nextPage,
                        isLoading: state.loading,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              AlreadyHaveAccount(
                onLoginTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
