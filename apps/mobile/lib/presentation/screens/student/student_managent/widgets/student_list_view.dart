import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_state.dart';
import 'student_list_item.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentManagementBloc, StudentManagementState>(
      builder: (context, state) {
        if (state is StudentManagementLoading) {
          return _buildLoadingList();
        }

        if (state is StudentManagementError) {
          return _buildErrorView(context, state.message);
        }

        if (state is StudentManagementLoaded) {
          if (state.students.isEmpty) {
            return _buildEmptyView(context);
          }
          return _buildStudentList(context, state);
        }

        if (state is StudentManagementLoadingMore) {
          return _buildStudentListWithLoadingMore(context, state);
        }

        if (state is StudentManagementFormLoading) {
          return _buildStudentListFromFormLoading(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

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
              // Avatar skeleton
              const SkeletonBox(height: 56, width: 56, borderRadius: 28),
              const SizedBox(width: 16),
              // Content skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonBox(
                            height: 20,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(width: 8),
                        SkeletonBox(height: 24, width: 40),
                      ],
                    ),
                    SizedBox(height: 8),
                    SkeletonBox(height: 16, width: 200),
                    SizedBox(height: 6),
                    SkeletonBox(height: 16, width: 250),
                    SizedBox(height: 6),
                    SkeletonBox(height: 16, width: 150),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SkeletonBox(height: 24, width: 24, borderRadius: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Container(
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
                context.read<StudentManagementBloc>().add(
                  RefreshStudentsEvent(),
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

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school_outlined,
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
              'Hãy thêm học sinh đầu tiên để bắt đầu quản lý',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<StudentManagementBloc>().add(
                  ShowCreateFormEvent(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm học sinh mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(
    BuildContext context,
    StudentManagementLoaded state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.students.length,
          itemBuilder: (context, index) {
            return StudentListItem(student: state.students[index]);
          },
        ),
        // Load more button if there are more items
        if (!state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              onPressed: () {
                context.read<StudentManagementBloc>().add(
                  LoadMoreStudentsEvent(),
                );
              },
              text: 'Xem thêm',
            ),
          ),
      ],
    );
  }

  Widget _buildStudentListWithLoadingMore(
    BuildContext context,
    StudentManagementLoadingMore state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.students.length,
          itemBuilder: (context, index) {
            return StudentListItem(student: state.students[index]);
          },
        ),
        // Loading indicator
        const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildStudentListFromFormLoading(
    BuildContext context,
    StudentManagementFormLoading state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.students.length,
          itemBuilder: (context, index) {
            return StudentListItem(student: state.students[index]);
          },
        ),
      ],
    );
  }
}
