import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/widgets/membership_filter_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/widgets/membership_request_item.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/sort_dropdown.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';

class MembershipRequestManagementPage extends StatefulWidget {
  const MembershipRequestManagementPage({super.key});

  @override
  State<MembershipRequestManagementPage> createState() =>
      _MembershipRequestManagementPageState();
}

class _MembershipRequestManagementPageState
    extends State<MembershipRequestManagementPage> {
  final ScrollController _scrollController = ScrollController();

  // Sort options
  static const Map<String, String> sortOptions = {
    'createdAt:desc': 'Mới nhất',
    'createdAt:asc': 'Cũ nhất',
    'updatedAt:desc': 'Cập nhật mới nhất',
    'updatedAt:asc': 'Cập nhật cũ nhất',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MembershipRequestManagementBloc>().add(
        const LoadMoreMembershipRequestsEvent(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSortChanged(String sortKey) {
    final sortParts = sortKey.split(':');
    if (sortParts.length == 2) {
      final sortMap = <String, String>{sortParts[0]: sortParts[1]};
      context.read<MembershipRequestManagementBloc>().add(
        SortMembershipRequestsEvent(sortMap),
      );
    }
  }

  void _onFilterChanged(Map<String, dynamic> filter) {
    context.read<MembershipRequestManagementBloc>().add(
      FilterMembershipRequestsEvent(filter),
    );
  }

  void _onRefresh() {
    context.read<MembershipRequestManagementBloc>().add(
      const RefreshMembershipRequestsEvent(),
    );
  }

  String _getCurrentSortKey(Map<String, String> currentSort) {
    if (currentSort.isEmpty) return 'createdAt:desc';
    final entry = currentSort.entries.first;
    return '${entry.key}:${entry.value}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Quản lý yêu cầu thành viên',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body:
          BlocBuilder<
            MembershipRequestManagementBloc,
            MembershipRequestManagementState
          >(
            builder: (context, state) {
              return Column(
                children: [
                  // Header với Filter và Sort
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: _buildHeader(state),
                  ),

                  // Danh sách
                  Expanded(child: _buildBody(state)),
                ],
              );
            },
          ),
    );
  }

  Widget _buildHeader(MembershipRequestManagementState state) {
    final currentSort = state is MembershipRequestLoaded
        ? state.currentSort
        : <String, String>{'createdAt': 'desc'};

    final currentFilter = state is MembershipRequestLoaded
        ? state.currentFilter
        : <String, dynamic>{};

    return Row(
      children: [
        // Filter
        Expanded(
          flex: 2,
          child: MembershipFilterWidget(
            currentFilter: currentFilter,
            onFilterChanged: _onFilterChanged,
          ),
        ),

        const SizedBox(width: 12),

        // Sort
        Expanded(
          child: SortDropdownWidget(
            currentSort: _getCurrentSortKey(currentSort),
            sortOptions: sortOptions,
            onSortChanged: _onSortChanged,
            placeholder: 'Sắp xếp',
          ),
        ),
      ],
    );
  }

  Widget _buildBody(MembershipRequestManagementState state) {
    if (state is MembershipRequestLoading) {
      return _buildLoadingSkeleton();
    }

    if (state is MembershipRequestError) {
      return _buildError(state.message);
    }

    if (state is MembershipRequestLoaded ||
        state is MembershipRequestLoadingMore) {
      final requests = state is MembershipRequestLoaded
          ? state.requests
          : (state as MembershipRequestLoadingMore).requests;

      final isLoadingMore = state is MembershipRequestLoadingMore;

      if (requests.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: requests.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= requests.length) {
            return _buildLoadingMoreIndicator();
          }

          final request = requests[index];
          final isUpdating =
              state is MembershipRequestUpdatingStatus &&
              state.updatingRequestId == request.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MembershipRequestItem(
              request: request,
              isUpdating: isUpdating,
              onStatusUpdate: (newStatus) {
                context.read<MembershipRequestManagementBloc>().add(
                  UpdateStatusEvent(request.id, newStatus),
                );
              },
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingSkeleton() {
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
                children: [
                  const SkeletonBox(width: 80, height: 20),
                  const Spacer(),
                  const SkeletonBox(width: 24, height: 24),
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

  Widget _buildError(String message) {
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
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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

  Widget _buildLoadingMoreIndicator() {
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
