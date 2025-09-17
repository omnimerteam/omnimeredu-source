import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/core/theme/theme_cubit.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/under_development_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dialog/logout_dialog_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeaderSection(context),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionTitle(context, 'Tài khoản'),
          const SizedBox(height: 12),
          _buildAccountSection(context),
          const SizedBox(height: 24),

          // App Settings Section
          _buildSectionTitle(context, 'Cài đặt ứng dụng'),
          const SizedBox(height: 12),
          _buildAppSettingsSection(context),
          const SizedBox(height: 24),

          // Premium Section
          _buildSectionTitle(context, 'Nâng cao'),
          const SizedBox(height: 12),
          _buildPremiumSection(context),
          const SizedBox(height: 24),

          // Support Section
          _buildSectionTitle(context, 'Hỗ trợ'),
          const SizedBox(height: 12),
          _buildSupportSection(context),
          const SizedBox(height: 24),

          // Logout Section
          _buildLogoutSection(context),
          const SizedBox(height: 24),

          // App Info
          _buildAppInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.more_horiz,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tùy chọn thêm',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cài đặt, hỗ trợ và các tính năng khác',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'Thông tin cá nhân',
            subtitle: 'Xem và chỉnh sửa thông tin',
            color: Colors.blue,
            onTap: () => _navigateToFeature(context, 'profile'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.security,
            title: 'Bảo mật',
            subtitle: 'Đổi mật khẩu, xác thực 2 bước',
            color: Colors.green,
            onTap: () => _navigateToFeature(context, 'security'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.privacy_tip,
            title: 'Quyền riêng tư',
            subtitle: 'Cài đặt quyền riêng tư',
            color: Colors.orange,
            onTap: () => _navigateToFeature(context, 'privacy'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSwitchMenuItem(
            context,
            icon: Icons.dark_mode,
            title: 'Chế độ tối',
            subtitle: 'Bật/tắt giao diện tối',
            color: Colors.indigo,
            value: context.watch<ThemeCubit>().state == ThemeMode.dark,
            onChanged: (value) => _toggleTheme(context),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.notifications,
            title: 'Thông báo',
            subtitle: 'Cài đặt thông báo push',
            color: Colors.red,
            onTap: () => _navigateToFeature(context, 'notifications'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.language,
            title: 'Ngôn ngữ',
            subtitle: 'Tiếng Việt',
            color: Colors.purple,
            onTap: () => _navigateToFeature(context, 'language'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.storage,
            title: 'Lưu trữ',
            subtitle: 'Quản lý bộ nhớ cache',
            color: Colors.brown,
            onTap: () => _navigateToFeature(context, 'storage'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.amber.withOpacity(0.1),
              Colors.orange.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              context,
              icon: Icons.workspace_premium,
              title: 'Nâng cấp VIP',
              subtitle: 'Mở khóa tính năng cao cấp',
              color: Colors.amber,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'HOT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => _navigateToFeature(context, 'premium'),
            ),
            const Divider(height: 1),
            _buildMenuItem(
              context,
              icon: Icons.card_giftcard,
              title: 'Mã khuyến mãi',
              subtitle: 'Nhập mã để nhận ưu đãi',
              color: Colors.pink,
              onTap: () => _navigateToFeature(context, 'promo_code'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.help,
            title: 'Trợ giúp',
            subtitle: 'Câu hỏi thường gặp',
            color: Colors.blue,
            onTap: () => _navigateToFeature(context, 'help'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.contact_support,
            title: 'Liên hệ hỗ trợ',
            subtitle: 'Gửi phản hồi hoặc báo lỗi',
            color: Colors.green,
            onTap: () => _navigateToFeature(context, 'contact_support'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.rate_review,
            title: 'Đánh giá ứng dụng',
            subtitle: 'Đánh giá 5 sao cho chúng tôi',
            color: Colors.orange,
            onTap: () => _navigateToFeature(context, 'rate_app'),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.share,
            title: 'Chia sẻ ứng dụng',
            subtitle: 'Giới thiệu cho bạn bè',
            color: Colors.purple,
            onTap: () => _shareApp(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: _buildMenuItem(
        context,
        icon: Icons.logout,
        title: 'Đăng xuất',
        subtitle: 'Thoát khỏi tài khoản hiện tại',
        color: Colors.red,
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Omnimer Education',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Phiên bản 1.0.0',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '© 2025 Tập đoàn Omnimer',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'contact@omnimer.com',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _navigateToFeature(BuildContext context, String featureName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnderDevelopmentScreen(featureName: featureName),
      ),
    );
  }

  void _toggleTheme(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  void _shareApp(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng chia sẻ ứng dụng đang được phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LogoutDialogWidget(
        onConfirm: () {
          Navigator.of(context).pop();
          context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
