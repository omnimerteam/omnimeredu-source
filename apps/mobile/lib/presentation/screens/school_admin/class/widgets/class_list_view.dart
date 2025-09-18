// widgets/class_list_view.dart - Fixed version
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_state.dart';
import 'class_list_item.dart';

class ClassListView extends StatelessWidget {
  const ClassListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        if (state is ClassManagementLoading) {
          return _buildLoadingList();
        }

        if (state is ClassManagementError) {
          return _buildErrorView(context, state.message);
        }

        if (state is ClassManagementLoaded) {
          if (state.classes.isEmpty) {
            return _buildEmptyView(context);
          }
          return _buildClassList(context, state);
        }

        if (state is ClassManagementLoadingMore) {
          return _buildClassListWithLoadingMore(context, state);
        }

        if (state is ClassManagementFormLoading) {
          return _buildClassListFromFormLoading(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingList() {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SkeletonBox(height: 20, width: 200)),
                  SizedBox(width: 12),
                  SkeletonBox(height: 24, width: 60),
                ],
              ),
              SizedBox(height: 12),
              SkeletonBox(height: 16, width: 150),
              SizedBox(height: 6),
              SkeletonBox(height: 16, width: 120),
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
                context.read<ClassManagementBloc>().add(
                  const RefreshClassesEvent(),
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
              Icons.class_,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có lớp học nào',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy tạo lớp học đầu tiên để bắt đầu quản lý',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ClassManagementBloc>().add(ShowCreateFormEvent());
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo lớp học mới'),
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

  Widget _buildClassList(BuildContext context, ClassManagementLoaded state) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.classes.length,
          itemBuilder: (context, index) {
            return ClassListItem(classDetail: state.classes[index]);
          },
        ),
        // Load more button if there are more items
        if (!state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                context.read<ClassManagementBloc>().add(
                  const LoadMoreClassesEvent(),
                );
              },
              child: const Text('Tải thêm'),
            ),
          ),
      ],
    );
  }

  Widget _buildClassListWithLoadingMore(
    BuildContext context,
    ClassManagementLoadingMore state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.classes.length,
          itemBuilder: (context, index) {
            return ClassListItem(classDetail: state.classes[index]);
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

  Widget _buildClassListFromFormLoading(
    BuildContext context,
    ClassManagementFormLoading state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.classes.length,
          itemBuilder: (context, index) {
            return ClassListItem(classDetail: state.classes[index]);
          },
        ),
      ],
    );
  }
}
