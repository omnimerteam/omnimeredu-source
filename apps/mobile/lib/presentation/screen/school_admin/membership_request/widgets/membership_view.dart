import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/membership_request_bloc.dart';
import '../bloc/membership_request_event.dart';
import '../bloc/membership_request_state.dart';
import 'membership_request_item.dart';
import '../../../../common/widgets/skeleton/common_skeleton.dart';

class MembershipSortView extends StatelessWidget {
  final MembershipRequestState state;
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: requests.length + (loadedState.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < requests.length) {
            final request = requests[index];
            final isUpdating =
                loadedState.formStatus == MembershipRequestFormStatus.loading &&
                loadedState.isFormVisible;

            return (request.id != null && request.id!.isNotEmpty)
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: MembershipRequestItem(
                      request: request,
                      isUpdating: isUpdating,
                      onStatusUpdate: (newStatus) {
                        context.read<MembershipRequestBloc>().add(
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
              padding: EdgeInsets.all(16.w),
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
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonBox(width: 80.w, height: 20.h),
                  const Spacer(),
                  SkeletonBox(width: 24.w, height: 24.w),
                ],
              ),
              SizedBox(height: 12.h),
              SkeletonBox(width: double.infinity, height: 16.h),
              SizedBox(height: 8.h),
              SkeletonBox(width: 200.w, height: 16.h),
              SizedBox(height: 8.h),
              SkeletonBox(width: 150.w, height: 16.h),
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
            size: 64.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Có lỗi xảy ra',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24.h),
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
            size: 64.sp,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có yêu cầu nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8.h),
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
      padding: EdgeInsets.all(16.w),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
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
