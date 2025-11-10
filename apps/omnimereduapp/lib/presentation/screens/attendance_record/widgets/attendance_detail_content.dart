import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../domain/entities/detail_record/detail_record_student_entity.dart';
import '../bloc/attendance_detail_bloc.dart';
import '../bloc/attendance_detail_event.dart';
import '../bloc/attendance_detail_state.dart';
import 'attendance_record_item.dart';
import '../../main_feature/teacher/widgets/attendance_dialog.dart';

class AttendanceDetailContent extends StatelessWidget {
  final AttendanceDetailLoaded state;
  final String attendanceId;

  const AttendanceDetailContent({
    super.key,
    required this.state,
    required this.attendanceId,
  });

  @override
  Widget build(BuildContext context) {
    if (state.records.isEmpty) {
      return const Center(
        child: Text(
          "Danh sách điểm danh trống",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final stats = _calculateStats(state.records);

    return Column(
      children: [
        _buildStatCards(context, stats),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              final record = state.records[index];
              return AttendanceRecordItem(
                record: record,
                onTap: () {
                  _openEditDialog(context, record);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _openEditDialog(BuildContext context, DetailRecordStudentEntity record) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final studentEntity = record.toStudentAttendanceEntity();

        return AttendanceDialog(
          student: studentEntity,
          onUpdate: (status, note) {
            context.read<AttendanceDetailBloc>().add(
              UpdateStudentStatus(
                recordId: studentEntity.detailRecordId,
                status: status,
                note: note,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật điểm danh thành công'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCards(BuildContext context, Map<String, int> stats) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống kê điểm danh',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  context,
                  'Tổng số',
                  stats['total']!,
                  Icons.people,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _statItem(
                  context,
                  'Có mặt',
                  stats['present']!,
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _statItem(
                  context,
                  'Vắng',
                  stats['absent']!,
                  Icons.cancel,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  context,
                  'Có phép',
                  stats['leave']!,
                  Icons.note,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _statItem(
                  context,
                  'Đi trễ',
                  stats['late']!,
                  Icons.access_time,
                  Colors.amber,
                ),
              ),
              Expanded(
                child: _statItem(
                  context,
                  'Về sớm',
                  stats['leftEarly']!,
                  Icons.logout,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    int value,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
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
