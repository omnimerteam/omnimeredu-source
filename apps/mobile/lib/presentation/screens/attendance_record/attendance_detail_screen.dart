import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_student_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_state.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';

class AttendanceDetailPage extends StatelessWidget {
  final String attendanceId;

  const AttendanceDetailPage({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return AttendanceDetailView(attendanceId: attendanceId);
  }
}

class AttendanceDetailView extends StatelessWidget {
  final String attendanceId;

  const AttendanceDetailView({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            return _buildLoadingView();
          }

          if (state is AttendanceDetailError) {
            return _buildErrorView(context, state.message);
          }

          if (state is AttendanceDetailLoaded) {
            return _buildDetailView(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(
        8,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const SkeletonBox(height: 56, width: 56, borderRadius: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 20, width: double.infinity),
                    SizedBox(height: 8),
                    SkeletonBox(height: 16, width: 200),
                    SizedBox(height: 6),
                    SkeletonBox(height: 16, width: 150),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SkeletonBox(height: 32, width: 80, borderRadius: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AttendanceDetailBloc>().add(
                  LoadAttendanceDetailEvent(attendanceId),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, AttendanceDetailLoaded state) {
    if (state.records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có học sinh nào',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Danh sách điểm danh trống',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Tính toán thống kê
    final stats = _calculateStats(state.records);

    return Column(
      children: [
        // Statistics Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thống kê điểm danh',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Dòng 1
              Row(
                children: [
                  _buildStatItem(
                    context,
                    'Tổng số',
                    '${stats['total']}',
                    Icons.people,
                  ),
                  _buildStatItem(
                    context,
                    'Có mặt',
                    '${stats['present']}',
                    Icons.check_circle,
                  ),
                  _buildStatItem(
                    context,
                    'Vắng',
                    '${stats['absent']}',
                    Icons.cancel,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Dòng 2
              Row(
                children: [
                  _buildStatItem(
                    context,
                    'Có phép',
                    '${stats['leave']}',
                    Icons.event_note,
                  ),
                  _buildStatItem(
                    context,
                    'Đi trễ',
                    '${stats['late']}',
                    Icons.access_time,
                  ),
                  _buildStatItem(
                    context,
                    'Về sớm',
                    '${stats['leftEarly']}',
                    Icons.exit_to_app,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Student List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              return _buildRecordItem(context, state.records[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(
    BuildContext context,
    DetailRecordStudentEntity record,
  ) {
    final student = record.studentId;
    final status = record.status ?? AttendanceStatusEnum.Absent;

    Color getStatusColor(AttendanceStatusEnum status) {
      switch (status) {
        case AttendanceStatusEnum.Present:
          return Colors.green;
        case AttendanceStatusEnum.Absent:
          return Colors.red;
        case AttendanceStatusEnum.AbsentWithLeave:
          return Colors.orange;
        case AttendanceStatusEnum.Late:
          return Colors.blue;
        case AttendanceStatusEnum.LeftEarly:
          return Colors.purple;
        case AttendanceStatusEnum.None:
          return Colors.grey;
      }
    }

    String getStatusText(AttendanceStatusEnum status) {
      switch (status) {
        case AttendanceStatusEnum.Present:
          return "Có mặt";
        case AttendanceStatusEnum.Absent:
          return "Vắng";
        case AttendanceStatusEnum.AbsentWithLeave:
          return "Có phép";
        case AttendanceStatusEnum.Late:
          return "Đi trễ";
        case AttendanceStatusEnum.LeftEarly:
          return "Về sớm";
        case AttendanceStatusEnum.None:
          return "Chưa điểm danh";
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Avatar tròn
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.15),
            child: Text(
              student?.name.isNotEmpty == true
                  ? student!.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Thông tin học sinh
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student?.name ?? "Không rõ tên",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Giới tính: ${student?.gender ?? '---'}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Phụ huynh: ${student?.guardianName ?? ''} (${student?.guardianPhone ?? ''})",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Trạng thái điểm danh
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: getStatusColor(status)),
            ),
            child: Text(
              getStatusText(status),
              style: TextStyle(
                color: getStatusColor(status),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats(List<DetailRecordStudentEntity> records) {
    int total = records.length;
    int present = records
        .where((e) => e.status == AttendanceStatusEnum.Present)
        .length;
    int absent = records
        .where((e) => e.status == AttendanceStatusEnum.Absent)
        .length;
    int leave = records
        .where((e) => e.status == AttendanceStatusEnum.AbsentWithLeave)
        .length;
    int late = records
        .where((e) => e.status == AttendanceStatusEnum.Late)
        .length;
    int leftEarly = records
        .where((e) => e.status == AttendanceStatusEnum.LeftEarly)
        .length;

    return {
      'total': total,
      'present': present,
      'absent': absent,
      'leave': leave,
      'late': late,
      'leftEarly': leftEarly,
    };
  }
}
