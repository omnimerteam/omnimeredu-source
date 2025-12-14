import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/enum_constant.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/registration_event.dart';
import '../../../../core/theme/app_colors.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_state.dart' as registration_state;
import 'bloc/school/school_bloc.dart';
import 'bloc/class/class_bloc.dart';
import 'widgets/already_have_account.dart';
import 'widgets/step_basic_info.dart';
import 'widgets/step_review.dart';
import 'widgets/step_role.dart';
import '../../../../domain/usecases/school/get_schools_by_level_usecase.dart';
import '../../../../domain/usecases/school/get_classes_by_school_usecase.dart';
import '../../../../domain/repositories/school_repository.dart';
import '../../../../domain/entities/auth/register_user_entity.dart';
import '../../../common/blocs/auth_bloc/auth_bloc.dart';

import '../../../../presentation/common/widgets/button/app_button.dart';

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
        return;
      }
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

    final registrationBloc = context.read<RegistrationBloc>();
    final authBloc = context.read<AuthBloc>();
    final registrationState = registrationBloc.state;

    // Build RegisterUserEntity from state
    final user = RegisterUserEntity(
      email: registrationState.email ?? "",
      password: registrationState.password ?? "",
      schoolId: registrationState.schoolId,
      classId: registrationState.classId,
      baseUserInfo: BaseUserForRegisterEntity(
        roleName: registrationState.selectedRole?.name ?? "",
        fullName: registrationState.fullName ?? "",
        gender: registrationState.gender ?? "Other",
        phone: registrationState.phone,
        birthday: registrationState.birthday,
        address: registrationState.address,
        avatar: registrationState.avatarFile,
      ),
      specificInfo: {
        // Student
        "guardianName": registrationState.guardianName,
        "guardianPhone": registrationState.guardianPhone,
        "educationLevel": registrationState.educationLevel?.name,
        // Teacher
        "qualification": registrationState.qualification?.name,
        "subjects": registrationState.subjects?.map((s) => s.name).toList(),
        // School Admin
        "position": registrationState.position?.name,
      },
      schoolData: registrationState.isCreateNewSchool
          ? SchoolDataEntity(
              name: registrationState.schoolName ?? "",
              address: registrationState.schoolAddress ?? "",
              phone: registrationState.schoolPhone,
              description: registrationState.schoolDescription,
              level:
                  registrationState.schoolLevel ??
                  EducationSystemLevelsEnum.Preschool,
            )
          : null,
    );

    // Send registration to AuthBloc
    authBloc.add(AuthRegisterRequested(user));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationBloc()),
        BlocProvider(
          create: (context) => SchoolBloc(
            getSchoolsByLevelUseCase: GetSchoolsByLevelUseCase(
              context.read<SchoolRepository>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ClassBloc(
            getClassesBySchoolUseCase: GetClassesBySchoolUseCase(
              context.read<SchoolRepository>(),
            ),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          title: const Text(
            'Đăng ký tài khoản',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
        ),
        body:
            BlocListener<
              RegistrationBloc,
              registration_state.RegistrationState
            >(
              listener: (context, state) {
                if (state.error != null) {
                  // Hiển thị lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              child: MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, authState) {
                      if (authState is AuthRegistered) {
                        // Nếu đăng ký thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đăng ký thành công!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.read<RegistrationBloc>().add(
                          ResetRegistration(),
                        );

                        // Điều hướng về màn hình login
                        Navigator.pushReplacementNamed(context, '/login');
                      } else if (authState is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authState.message),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
                child:
                    BlocBuilder<
                      RegistrationBloc,
                      registration_state.RegistrationState
                    >(
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
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
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
                                  onPageChanged: (p) =>
                                      setState(() => currentPage = p),
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
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, authState) {
                                  return Row(
                                    children: [
                                      if (currentPage > 0)
                                        Expanded(
                                          child: AppButton(
                                            text: 'Quay lại',
                                            onPressed: _previousPage,
                                            type: AppButtonType.cancel,
                                          ),
                                        ),
                                      if (currentPage > 0)
                                        SizedBox(width: 16.w),
                                      Expanded(
                                        child: AppButton(
                                          text: currentPage == totalPages - 1
                                              ? 'Đăng ký'
                                              : 'Tiếp tục',
                                          onPressed:
                                              currentPage == totalPages - 1
                                              ? _submitRegistration
                                              : _nextPage,
                                          loading:
                                              (currentPage == totalPages - 1) &&
                                              (authState is AuthLoading),
                                          type: AppButtonType.primary,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AlreadyHaveAccount(
                              onLoginTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
              ),
            ),
      ),
    );
  }
}
