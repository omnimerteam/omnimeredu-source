import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/attendance_detail_bloc.dart';
import 'bloc/attendance_detail_event.dart';
import 'bloc/attendance_detail_state.dart';
import 'widgets/attendance_detail_error.dart';
import 'widgets/attendance_detail_loading_view.dart';
import 'widgets/attendance_detail_content.dart';

class AttendanceDetailPage extends StatelessWidget {
  final String attendanceId;
  const AttendanceDetailPage({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết điểm danh'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            tooltip: "Tải lại",
            onPressed: () {
              context.read<AttendanceDetailBloc>().add(
                RefreshAttendanceDetailEvent(attendanceId),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceDetailBloc, AttendanceDetailState>(
        builder: (context, state) {
          if (state is AttendanceDetailLoading) {
            return const AttendanceDetailLoadingView();
          } else if (state is AttendanceDetailError) {
            return AttendanceDetailErrorView(
              message: state.message,
              onRetry: () => context.read<AttendanceDetailBloc>().add(
                LoadAttendanceDetailEvent(attendanceId),
              ),
            );
          } else if (state is AttendanceDetailLoaded) {
            return AttendanceDetailContent(
              state: state,
              attendanceId: attendanceId,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
