import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  final String featureName;

  const UnderDevelopmentScreen({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_getFeatureTitle(featureName)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getFeatureIcon(featureName),
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Tính năng đang phát triển',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Feature Name
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getFeatureTitle(featureName),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                _getFeatureDescription(featureName),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Progress Indicator
              _buildProgressIndicator(context),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),
              const SizedBox(height: 24),

              // Contact Info
              _buildContactInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiến độ phát triển',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${_getFeatureProgress(featureName)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0.0,
                end: _getFeatureProgress(featureName) / 100,
              ),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 8,
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              _getProgressStatus(featureName),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
            label: const Text(
              'Quay lại',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _sendFeedback(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.feedback),
            label: const Text(
              'Gửi góp ý',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Thông tin liên hệ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'contact@omnimer.com',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '+84 123 456 789',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFeatureTitle(String featureName) {
    switch (featureName) {
      case 'schedule':
        return 'Thời khóa biểu';
      case 'assignments':
        return 'Bài tập';
      case 'grades':
        return 'Điểm số';
      case 'attendance':
        return 'Điểm danh';
      case 'messages':
        return 'Tin nhắn';
      case 'profile':
        return 'Thông tin cá nhân';
      case 'premium':
        return 'Nâng cấp VIP';
      case 'notifications':
        return 'Thông báo';
      case 'help':
        return 'Trợ giúp';
      default:
        return 'Tính năng mới';
    }
  }

  String _getFeatureDescription(String featureName) {
    switch (featureName) {
      case 'schedule':
        return 'Tính năng xem thời khóa biểu chi tiết theo ngày, tuần, tháng với các thông tin lớp học, giáo viên và phòng học.';
      case 'assignments':
        return 'Quản lý bài tập được giao, nộp bài trực tuyến và theo dõi tiến độ hoàn thành các nhiệm vụ học tập.';
      case 'grades':
        return 'Xem điểm số chi tiết theo từng môn học, học kỳ và thống kê kết quả học tập qua các giai đoạn.';
      case 'attendance':
        return 'Hệ thống điểm danh thông minh với nhiều phương thức như QR code, GPS và nhận diện khuôn mặt.';
      case 'premium':
        return 'Nâng cấp tài khoản VIP để trải nghiệm các tính năng cao cấp và loại bỏ giới hạn sử dụng.';
      default:
        return 'Chúng tôi đang nỗ lực phát triển tính năng này để mang đến trải nghiệm tốt nhất cho bạn.';
    }
  }

  IconData _getFeatureIcon(String featureName) {
    switch (featureName) {
      case 'schedule':
        return Icons.schedule;
      case 'assignments':
        return Icons.assignment;
      case 'grades':
        return Icons.grade;
      case 'attendance':
        return Icons.how_to_reg;
      case 'messages':
        return Icons.message;
      case 'profile':
        return Icons.person;
      case 'premium':
        return Icons.workspace_premium;
      case 'notifications':
        return Icons.notifications;
      case 'help':
        return Icons.help;
      default:
        return Icons.construction;
    }
  }

  int _getFeatureProgress(String featureName) {
    // Simulate different progress for different features
    switch (featureName) {
      case 'schedule':
        return 75;
      case 'assignments':
        return 60;
      case 'grades':
        return 85;
      case 'attendance':
        return 45;
      case 'messages':
        return 30;
      case 'profile':
        return 90;
      case 'premium':
        return 20;
      default:
        return 50;
    }
  }

  String _getProgressStatus(String featureName) {
    final progress = _getFeatureProgress(featureName);
    if (progress >= 80) {
      return 'Sắp hoàn thành - Dự kiến ra mắt trong tháng này';
    } else if (progress >= 60) {
      return 'Đang trong giai đoạn kiểm thử - Ra mắt trong 2 tháng tới';
    } else if (progress >= 40) {
      return 'Đang phát triển tích cực - Hoàn thành trong quý này';
    } else {
      return 'Bắt đầu phát triển - Thời gian hoàn thành chưa xác định';
    }
  }

  void _sendFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Cảm ơn bạn đã quan tâm! Chức năng gửi góp ý sẽ sớm được bổ sung.',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
