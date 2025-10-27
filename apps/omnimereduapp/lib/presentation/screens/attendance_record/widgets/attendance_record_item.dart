import 'package:flutter/material.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../domain/entities/detail_record/detail_record_student_entity.dart';

class AttendanceRecordItem extends StatelessWidget {
  final DetailRecordStudentEntity record;
  final VoidCallback onTap;

  const AttendanceRecordItem({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final student = record.studentId;
    final status = record.status ?? AttendanceStatusEnum.Absent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Phụ huynh: ${student?.guardianName ?? ''} (${student?.guardianPhone ?? ''})",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _statusColor(status)),
              ),
              child: Text(
                status.displayName,
                style: TextStyle(
                  color: _statusColor(status),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(AttendanceStatusEnum status) {
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
      default:
        return Colors.grey;
    }
  }
}
