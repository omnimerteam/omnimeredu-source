import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/presentation/common/widgets/skeleton/common_skeleton.dart';
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
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GradeManagementBloc>().add(
                        const LoadMoreGradesEvent(),
                      );
                    },
                    child: state is GradeManagementLoadingMore
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
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
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SkeletonBox(height: 20.h, width: 150.w),
                    const Spacer(),
                    SkeletonBox(height: 20.h, width: 60.w),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SkeletonBox(height: 16.h, width: 100.w),
                    SizedBox(width: 16.w),
                    SkeletonBox(height: 16.h, width: 80.w),
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
            size: 64.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text('Có lỗi xảy ra', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          const Text(
            'Chưa có khối nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          const Text(
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
