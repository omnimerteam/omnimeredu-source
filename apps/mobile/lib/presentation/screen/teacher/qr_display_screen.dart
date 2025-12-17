import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/usecases/qr_attendance/generate_qr_code_usecase.dart';
import 'bloc/qr/qr_display_bloc.dart';
import 'bloc/qr/qr_display_event.dart';
import 'bloc/qr/qr_display_state.dart';
import 'widgets/attendance_info_card.dart';
import 'widgets/qr_code_widget.dart';
import 'widgets/qr_timer_widget.dart';

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
      create: (context) =>
          QRDisplayBloc(generateQRCode: GetIt.I<GenerateQRCodeUseCase>())
            ..add(GenerateQRCodeEvent(attendanceId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mã QR Điểm Danh'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<QRDisplayBloc, QRDisplayState>(
          builder: (context, state) {
            if (state is QRDisplayLoading || state is QRDisplayInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QRDisplayError) {
              return Center(child: Text(state.message));
            } else if (state is QRDisplaySuccess) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    QRCodeWidget(data: state.qrCode.qrData),
                    SizedBox(height: 24.h),
                    QRTimerWidget(
                      remainingSeconds: state.remainingSeconds,
                      isExpired: state.isExpired,
                    ),
                    SizedBox(height: 24.h),
                    AttendanceInfoCard(
                      className: className,
                      subject: subject,
                      date: date,
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<QRDisplayBloc>().add(
                          RefreshQRCodeEvent(attendanceId),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Làm mới QR'),
                    ),
                  ],
                ),
              );
            } else if (state is QRDisplayExpired) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mã QR đã hết hạn',
                      style: TextStyle(fontSize: 18.sp, color: AppColors.red),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<QRDisplayBloc>().add(
                          RefreshQRCodeEvent(attendanceId),
                        );
                      },
                      child: const Text('Tạo mã mới'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
