import 'package:flutter/material.dart';
import 'package:omnimereduapp/presentation/widgets/skeleton/common_skeleton.dart';

/// 🔹 Widget hiển thị khi đang tạo attendance
class AttendanceInitializingState extends StatelessWidget {
  const AttendanceInitializingState({super.key});

  @override
  Widget build(BuildContext context) {
    return AttendanceLoadingContainer(
      icon: const CircularProgressIndicator(),
      title: 'Đang tạo bảng điểm danh...',
      subtitle: 'Vui lòng đợi trong giây lát',
    );
  }
}

/// 🔹 Widget hiển thị khi đang xóa attendance
class AttendanceDeletingState extends StatelessWidget {
  const AttendanceDeletingState({super.key});

  @override
  Widget build(BuildContext context) {
    return AttendanceLoadingContainer(
      icon: const CircularProgressIndicator(color: Colors.redAccent),
      title: 'Đang xóa bảng điểm danh...',
      subtitle: 'Vui lòng đợi trong giây lát',
    );
  }
}

/// 🔹 Widget chung cho các trạng thái loading
class AttendanceLoadingContainer extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const AttendanceLoadingContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 🔹 Widget hiển thị khi chưa có attendance record
class AttendanceNoDataState extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onCreatePressed;

  const AttendanceNoDataState({
    super.key,
    required this.selectedDate,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có bảng điểm danh',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có bảng điểm danh cho ngày '
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreatePressed,
            icon: const Icon(Icons.add),
            label: const Text('Tạo bảng điểm danh'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Widget hiển thị empty state chung
class AttendanceEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;

  const AttendanceEmptyState({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Widget hiển thị table loading skeleton
class AttendanceTableLoading extends StatelessWidget {
  const AttendanceTableLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(height: 20, width: 150),
              SkeletonBox(height: 40, width: 40, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: List.generate(
                  6,
                  (i) => const Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: SkeletonBox(height: 40),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Widget hiển thị stats loading skeleton
class AttendanceStatsLoading extends StatelessWidget {
  const AttendanceStatsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (index) => const SkeletonBox(height: 20, width: 60),
        ),
      ),
    );
  }
}
