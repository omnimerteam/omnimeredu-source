import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/skeleton/common_skeleton.dart';
import '../bloc/attendance_management_bloc.dart';
import '../bloc/attendance_management_event.dart';
import '../bloc/attendance_management_state.dart';
import 'attendance_list_item.dart';

class AttendanceListView extends StatelessWidget {
  const AttendanceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceManagementBloc, AttendanceManagementState>(
      builder: (context, state) {
        if (state is AttendanceManagementLoading) {
          return _buildLoadingList();
        }

        if (state is AttendanceManagementError) {
          return _buildErrorView(context, state.message);
        }

        if (state is AttendanceManagementLoaded ||
            state is AttendanceManagementLoadingMore) {
          final attendances = state is AttendanceManagementLoaded
              ? state.attendances
              : (state as AttendanceManagementLoadingMore).attendances;

          if (attendances == null || attendances.isEmpty) {
            return _buildEmptyView(context);
          }

          final hasReachedMax = state is AttendanceManagementLoaded
              ? state.hasReachedMax
              : false;

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendances.length,
                itemBuilder: (context, index) {
                  final attendance = attendances[index];
                  return AttendanceListItem(attendance: attendance);
                },
              ),

              // Load more button
              if (!hasReachedMax)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AttendanceManagementBloc>().add(
                        LoadMoreAttendancesEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state is AttendanceManagementLoadingMore
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Tải thêm'),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ===============================
  // 📍 Loading view
  Widget _buildLoadingList() {
    return Column(
      children: List.generate(
        6,
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
                    SizedBox(height: 8),
                    SkeletonBox(height: 14, width: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // 📍 Error view
  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Không thể tải dữ liệu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AttendanceManagementBloc>().add(
                  RefreshAttendancesEvent(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // 📍 Empty view
  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có dữ liệu điểm danh',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AttendanceManagementBloc>().add(
                  RefreshAttendancesEvent(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }
}
