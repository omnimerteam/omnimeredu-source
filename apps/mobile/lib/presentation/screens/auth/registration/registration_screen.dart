import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/text_field/app_text_field.dart';
import '../../../widgets/button/app_button.dart';
import '../../../widgets/image_picker/app_image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;

  // Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final roleCtrl = TextEditingController();
  final guardianCtrl = TextEditingController();
  final schoolNameCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    roleCtrl.dispose();
    guardianCtrl.dispose();
    schoolNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Đăng ký tài khoản",
          style: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          return Column(
            children: [
              Expanded(
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 4) {
                      setState(() => _currentStep += 1);
                    } else {
                      context.read<RegistrationBloc>().add(
                        RegistrationSubmitted(),
                      );
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    }
                  },
                  steps: [
                    Step(
                      title: const Text(
                        "Tài khoản",
                        style: TextStyle(fontFamily: "Nunito"),
                      ),
                      isActive: _currentStep >= 0,
                      content: Column(
                        children: [
                          AppTextField(controller: emailCtrl, label: "Email"),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: passCtrl,
                            label: "Mật khẩu",
                            obscure: true,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        "Cá nhân",
                        style: TextStyle(fontFamily: "Nunito"),
                      ),
                      isActive: _currentStep >= 1,
                      content: Column(
                        children: [
                          AppTextField(controller: nameCtrl, label: "Họ tên"),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: phoneCtrl,
                            label: "Số điện thoại",
                          ),
                          const SizedBox(height: 12),
                          AppImagePicker(
                            label: "Chọn Avatar",
                            onPicked: (f) => context
                                .read<RegistrationBloc>()
                                .add(RegistrationPickAvatar(f)),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        "Vai trò",
                        style: TextStyle(fontFamily: "Nunito"),
                      ),
                      isActive: _currentStep >= 2,
                      content: Column(
                        children: [
                          AppTextField(controller: roleCtrl, label: "RoleId"),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: guardianCtrl,
                            label: "Guardian Name (Student)",
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        "Trường",
                        style: TextStyle(fontFamily: "Nunito"),
                      ),
                      isActive: _currentStep >= 3,
                      content: Column(
                        children: [
                          AppTextField(
                            controller: schoolNameCtrl,
                            label: "Tên trường",
                          ),
                          const SizedBox(height: 12),
                          AppImagePicker(
                            label: "Logo Trường",
                            onPicked: (f) => context
                                .read<RegistrationBloc>()
                                .add(RegistrationPickSchoolLogo(f)),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        "Xác nhận",
                        style: TextStyle(fontFamily: "Nunito"),
                      ),
                      isActive: _currentStep >= 4,
                      content: AppButton(
                        text: "Đăng ký",
                        loading: state.loading,
                        onPressed: () => context.read<RegistrationBloc>().add(
                          RegistrationSubmitted(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔥 Thêm nút chuyển đổi Đăng nhập / Đăng ký
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bạn đã có tài khoản?",
                      style: TextStyle(fontFamily: "Inter", fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.blue,
                        ),
                      ),
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
}
