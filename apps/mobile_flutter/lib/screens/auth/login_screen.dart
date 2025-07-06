import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60),
                  _buildLogo(),
                  SizedBox(height: 40),
                  _buildTitle(),
                  SizedBox(height: 40),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 16),
                  _buildForgotPassword(),
                  SizedBox(height: 32),
                  _buildLoginButton(),
                  SizedBox(height: 24),
                  _buildDivider(),
                  SizedBox(height: 24),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue[200]!, width: 2),
      ),
      child: Icon(Icons.school, size: 60, color: Colors.blue[800]),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Quản lý học sinh',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập email';
        }
        if (!value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[700]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue[700],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(color: Colors.blue[700]),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đăng nhập thành công!')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: Text(
        'Đăng nhập',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('hoặc', style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue[700],
        side: BorderSide(color: Colors.blue[700]!),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'Tạo tài khoản mới',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
