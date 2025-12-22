import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/qr_theme.dart';
import 'bloc/qr_display_bloc.dart';
import 'bloc/qr_display_event.dart';
import 'bloc/qr_display_state.dart';
import 'widgets/qr_code_widget.dart';
import 'widgets/qr_timer_widget.dart';
import 'widgets/attendance_info_card.dart';

/// Screen hiển thị QR Code cho giáo viên
class QRDisplayScreen extends StatelessWidget {
  final String attendanceId;
  final String className;
  final String? subject;
  final DateTime date;

  const QRDisplayScreen({
    Key? key,
    required this.attendanceId,
    required this.className,
    this.subject,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<QRDisplayBloc>()
        ..add(GenerateQRCodeEvent(attendanceId)),
      child: _QRDisplayScreenContent(
        attendanceId: attendanceId,
        className: className,
        subject: subject,
        date: date,
      ),
    );
  }
}

class _QRDisplayScreenContent extends StatelessWidget {
  final String attendanceId;
  final String className;
  final String? subject;
  final DateTime date;

  const _QRDisplayScreenContent({
    Key? key,
    required this.attendanceId,
    required this.className,
    this.subject,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Restore brightness when leaving screen
        context.read<QRDisplayBloc>().add(const DisposeQRDisplayEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Mã QR Điểm Danh',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textLight,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textLight),
        ),
        body: BlocBuilder<QRDisplayBloc, QRDisplayState>(
          builder: (context, state) {
            if (state is QRDisplayLoading) {
              return _buildLoadingView(context);
            } else if (state is QRDisplaySuccess) {
              return _buildSuccessView(context, state);
            } else if (state is QRDisplayExpired) {
              return _buildExpiredView(context, state);
            } else if (state is QRDisplayError) {
              return _buildErrorView(context, state);
            }
            return _buildLoadingView(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Đang tạo mã QR...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, QRDisplaySuccess state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // QR Code
          BrandedQRCodeWidget(
            data: state.qrCode.qrData,
          ),
          const SizedBox(height: 24),
          // Timer
          QRTimerWidget(
            remainingSeconds: state.remainingSeconds,
            isExpired: state.isExpired,
          ),
          const SizedBox(height: 24),
          // Attendance Info
          AttendanceInfoCard(
            className: className,
            subject: subject,
            date: date,
          ),
          const SizedBox(height: 24),
          // Refresh Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<QRDisplayBloc>().add(
                  RefreshQRCodeEvent(attendanceId),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tạo mã mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Instruction text
          Text(
            'Sinh viên cần quét mã QR này để điểm danh',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredView(BuildContext context, QRDisplayExpired state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Mã QR đã hết hạn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vui lòng tạo mã mới để sinh viên có thể điểm danh',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<QRDisplayBloc>().add(
                    RefreshQRCodeEvent(attendanceId),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tạo mã mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, QRDisplayError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<QRDisplayBloc>().add(
                    GenerateQRCodeEvent(attendanceId),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

