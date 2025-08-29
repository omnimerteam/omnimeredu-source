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
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: passCtrl,
                      focusNode: passFocus,
                      hintText: "Mật khẩu",
                      prefixIcon: Icons.lock,
                      isFocused: passFocus.hasFocus,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: nameCtrl,
                      focusNode: nameFocus,
                      hintText: "Họ và tên",
                      prefixIcon: Icons.person,
                      isFocused: nameFocus.hasFocus,
                    ),
                    const SizedBox(height: 12),
                    PrimaryTextField(
                      controller: phoneCtrl,
                      focusNode: phoneFocus,
                      hintText: "Số điện thoại",
                      prefixIcon: Icons.phone,
                      isFocused: phoneFocus.hasFocus,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedRoleId,
                      decoration: InputDecoration(
                        labelText: "Chọn vai trò",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: state.roles.map((role) {
                        return DropdownMenuItem(
                          value: role.id,
                          child: Text(role.description ?? role.name),
                          onTap: () {
                            selectedRoleName = role.name;
                          },
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedRoleId = val),
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
                  children: [
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
