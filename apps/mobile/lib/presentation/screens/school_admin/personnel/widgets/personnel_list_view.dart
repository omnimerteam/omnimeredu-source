import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_state.dart';
import 'personnel_list_item.dart';

class PersonnelListView extends StatelessWidget {
  const PersonnelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonnelManagementBloc, PersonnelManagementState>(
      builder: (context, state) {
        if (state is PersonnelManagementLoading) {
          return _buildLoadingList();
        }

        if (state is PersonnelManagementError) {
          return _buildErrorView(context, state.message);
        }

        if (state is PersonnelManagementLoaded) {
          if (state.personnel.isEmpty) {
            return _buildEmptyView(context);
          }
          return _buildPersonnelList(context, state);
        }

        if (state is PersonnelManagementLoadingMore) {
          return _buildPersonnelListWithLoadingMore(context, state);
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
                        SkeletonBox(height: 24, width: 60),
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
                context.read<PersonnelManagementBloc>().add(
                  RefreshPersonnelEvent(),
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
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có nhân sự nào',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Danh sách nhân sự trống',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonnelList(
    BuildContext context,
    PersonnelManagementLoaded state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.personnel.length,
          itemBuilder: (context, index) {
            return PersonnelListItem(personnel: state.personnel[index]);
          },
        ),
        // Load more button if there are more items
        if (!state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              onPressed: () {
                context.read<PersonnelManagementBloc>().add(
                  LoadMorePersonnelEvent(),
                );
              },
              text: 'Xem thêm',
            ),
          ),
      ],
    );
  }

  Widget _buildPersonnelListWithLoadingMore(
    BuildContext context,
    PersonnelManagementLoadingMore state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.personnel.length,
          itemBuilder: (context, index) {
            return PersonnelListItem(personnel: state.personnel[index]);
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
}
