import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/change_password/cubit/change_password_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/change_password/cubit/change_password_state.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/validator.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _oldPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isOldPasswordFocused = false;
  bool _isNewPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _oldPasswordFocus.addListener(() {
      setState(() => _isOldPasswordFocused = _oldPasswordFocus.hasFocus);
    });
    _newPasswordFocus.addListener(() {
      setState(() => _isNewPasswordFocused = _newPasswordFocus.hasFocus);
    });
    _confirmPasswordFocus.addListener(() {
      setState(
        () => _isConfirmPasswordFocused = _confirmPasswordFocus.hasFocus,
      );
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordCubit>().changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu'), centerTitle: true),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Quay lại màn hình trước sau 1.5s
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header text
                  Text(
                    'Thay đổi mật khẩu',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vui lòng nhập mật khẩu cũ và mật khẩu mới của bạn',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mật khẩu cũ
                  PrimaryTextField(
                    controller: _oldPasswordController,
                    focusNode: _oldPasswordFocus,
                    hintText: 'Mật khẩu cũ',
                    prefixIcon: Icons.lock_outline,
                    isFocused: _isOldPasswordFocused,
                    obscureText: _obscureOldPassword,
                    required: true,
                    validator: (v) =>
                        Validators.requiredField(v, name: "Mật khẩu cũ"),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOldPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mật khẩu mới
                  PrimaryTextField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    hintText: 'Mật khẩu mới',
                    prefixIcon: Icons.lock,
                    isFocused: _isNewPasswordFocused,
                    obscureText: _obscureNewPassword,
                    required: true,
                    validator: (v) =>
                        Validators.requiredField(v, name: "Mật khẩu mới") ??
                        Validators.password(v),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Xác nhận mật khẩu mới
                  PrimaryTextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    hintText: 'Xác nhận mật khẩu mới',
                    prefixIcon: Icons.lock_reset,
                    isFocused: _isConfirmPasswordFocused,
                    obscureText: _obscureConfirmPassword,
                    required: true,
                    validator: (v) => Validators.confirmPassword(
                      v,
                      _newPasswordController.text,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Hủy',
                          type: AppButtonType.cancel,
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Đổi mật khẩu',
                          type: AppButtonType.primary,
                          loading: isLoading,
                          onPressed: isLoading ? null : _handleChangePassword,
                        ),
                      ),
                    ],
                  ),

                  // Ghi chú bảo mật
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Mật khẩu mới phải có ít nhất 6 ký tự và khác với mật khẩu cũ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
