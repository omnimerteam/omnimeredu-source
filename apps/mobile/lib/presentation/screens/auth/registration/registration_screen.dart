import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';

import '../../../widgets/button/app_button.dart';
import '../../../widgets/text_field/primary_text_field.dart';
import 'widgets/school_admin_form.dart';
import 'widgets/student_form.dart';
import 'widgets/other_role_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  bool _agreeTerms = false;

  // Controllers & FocusNodes cho step 1
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();

  String? selectedRoleId;
  String? selectedRoleName;

  @override
  void initState() {
    super.initState();
    // 👉 Khi mở màn hình, load roles từ API
    context.read<RegistrationBloc>().add(RegistrationLoadRoles());
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký tài khoản"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đăng ký thành công!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Ví dụ: quay về màn login
          }
        },
        builder: (context, state) {
          return Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                if (_agreeTerms) {
                  context.read<RegistrationBloc>().add(RegistrationSubmitted());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng đồng ý điều khoản")),
                  );
                }
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep--);
            },
            steps: [
              // STEP 1
              Step(
                title: const Text("Thông tin cơ bản"),
                isActive: _currentStep >= 0,
                content: Column(
                  children: [
                    PrimaryTextField(
                      controller: emailCtrl,
                      focusNode: emailFocus,
                      hintText: "Email",
                      prefixIcon: Icons.email,
                      isFocused: emailFocus.hasFocus,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => context.read<RegistrationBloc>().add(
                        RegistrationEmailChanged(val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: passCtrl,
                      focusNode: passFocus,
                      hintText: "Mật khẩu",
                      prefixIcon: Icons.lock,
                      isFocused: passFocus.hasFocus,
                      obscureText: true,
                      onChanged: (val) => context.read<RegistrationBloc>().add(
                        RegistrationPasswordChanged(val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: nameCtrl,
                      focusNode: nameFocus,
                      hintText: "Họ và tên",
                      prefixIcon: Icons.person,
                      isFocused: nameFocus.hasFocus,
                      onChanged: (val) => context.read<RegistrationBloc>().add(
                        RegistrationFullNameChanged(val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: phoneCtrl,
                      focusNode: phoneFocus,
                      hintText: "Số điện thoại",
                      prefixIcon: Icons.phone,
                      isFocused: phoneFocus.hasFocus,
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => context.read<RegistrationBloc>().add(
                        RegistrationPhoneChanged(val),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dropdown hiển thị roles từ API
                    DropdownButtonFormField<String>(
                      value: (selectedRoleId?.isNotEmpty ?? false)
                          ? selectedRoleId
                          : null,
                      hint: const Text("Chọn vai trò"),
                      items: state.roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role.id,
                          child: Text(
                            role.description,
                          ), // hoặc role.name nếu muốn
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRoleId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn vai trò';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // STEP 2: Role-specific form
              Step(
                title: const Text("Chi tiết"),
                isActive: _currentStep >= 1,
                content: _buildRoleSpecificForm(),
              ),

              // STEP 3: Confirm
              Step(
                title: const Text("Xác nhận"),
                isActive: _currentStep >= 2,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📧 Email: ${state.email}"),
                    Text("👤 Họ tên: ${state.fullName}"),
                    Text("📱 SĐT: ${state.phone ?? ''}"),
                    Text("🎭 Vai trò: $selectedRoleName"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeTerms,
                          onChanged: (val) {
                            setState(() => _agreeTerms = val ?? false);
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Tôi đồng ý với điều khoản và chính sách",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      text: "Đăng ký",
                      loading: state.loading,
                      onPressed: () {
                        if (_agreeTerms) {
                          context.read<RegistrationBloc>().add(
                            RegistrationSubmitted(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoleSpecificForm() {
    switch (selectedRoleName) {
      case "SchoolAdmin":
        return SchoolAdminForm();
      case "Student":
        return StudentForm();
      default:
        return OtherRoleForm();
    }
  }
}
