import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/skeleton/common_skeleton.dart';
import '../bloc/grade_management_bloc.dart';
import '../bloc/grade_management_event.dart';
import '../bloc/grade_management_state.dart';
import 'grade_list_item.dart';

class GradeListView extends StatelessWidget {
  const GradeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeManagementBloc, GradeManagementState>(
      builder: (context, state) {
        if (state is GradeManagementLoading) {
          return _buildLoadingView();
        }

        if (state is GradeManagementError) {
          return _buildErrorView(context, state.message);
        }

        if (state is GradeManagementLoaded) {
          if (state.grades.isEmpty) {
            return _buildEmptyView();
          }

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.grades.length,
                itemBuilder: (context, index) {
                  return GradeListItem(
                    grade: state.grades[index],
                    onEdit: (grade) {
                      context.read<GradeManagementBloc>().add(
                        LoadGradeForEditEvent(grade),
                      );
                    },
                    onDelete: (gradeId) {
                      _deleteGrade(context, gradeId);
                    },
                    onViewDetails: (grade) {
                      // Navigate to grade details page
                      Navigator.pushNamed(
                        context,
                        '/grade-details',
                        arguments: grade,
                      );
                    },
                  );
                },
              ),

              // Load more button
              if (!state.hasReachedMax)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GradeManagementBloc>().add(
                        const LoadMoreGradesEvent(),
                      );
                    },
                    child: state is GradeManagementLoadingMore
                        ? const SizedBox(
                            height: 20,
                            width: 20,
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

  Widget _buildLoadingView() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    SkeletonBox(height: 20, width: 150),
                    Spacer(),
                    SkeletonBox(height: 20, width: 60),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SkeletonBox(height: 16, width: 100),
                    SizedBox(width: 16),
                    SkeletonBox(height: 16, width: 80),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('Có lỗi xảy ra', style: Theme.of(context).textTheme.titleLarge),
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
              context.read<GradeManagementBloc>().add(const LoadGradesEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có khối nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tạo khối đầu tiên cho trường học của bạn',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _deleteGrade(BuildContext context, String gradeId) {
    context.read<GradeManagementBloc>().add(DeleteGradeEvent(gradeId));
  }
}
