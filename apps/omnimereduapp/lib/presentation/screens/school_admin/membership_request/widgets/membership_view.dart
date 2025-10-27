import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/membership_request_management_bloc.dart';
import '../bloc/membership_request_management_event.dart';
import '../bloc/membership_request_management_state.dart';
import 'membership_request_item.dart';
import '../../../../widgets/skeleton/common_skeleton.dart';

class MembershipSortView extends StatelessWidget {
  final MembershipRequestManagementState state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;

  const MembershipSortView({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (state is MembershipRequestLoading) {
      return _buildLoadingSkeleton(context);
    }

    if (state is MembershipRequestError) {
      return _buildError(context, (state as MembershipRequestError).message);
    }

    if (state is MembershipRequestLoaded) {
      final loadedState = state as MembershipRequestLoaded;
      final requests = loadedState.requests;

      if (requests.isEmpty) return _buildEmptyState(context);

      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: requests.length + (loadedState.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < requests.length) {
            final request = requests[index];
            final isUpdating =
                loadedState.formStatus == MembershipRequestFormStatus.loading &&
                loadedState.isFormVisible;

            return (request.id != null && request.id!.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MembershipRequestItem(
                      request: request,
                      isUpdating: isUpdating,
                      onStatusUpdate: (newStatus) {
                        context.read<MembershipRequestManagementBloc>().add(
                          UpdateStatusEvent(
                            requestId: request.id!,
                            newStatus: newStatus,
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink();
          } else {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: _buildLoadingMoreIndicator(context),
            );
          }
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  SkeletonBox(width: 80, height: 20),
                  Spacer(),
                  SkeletonBox(width: 24, height: 24),
                ],
              ),
              const SizedBox(height: 12),
              const SkeletonBox(width: double.infinity, height: 16),
              const SizedBox(height: 8),
              const SkeletonBox(width: 200, height: 16),
              const SizedBox(height: 8),
              const SkeletonBox(width: 150, height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có yêu cầu nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Các yêu cầu thành viên sẽ hiển thị ở đây',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Đang tải thêm...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
