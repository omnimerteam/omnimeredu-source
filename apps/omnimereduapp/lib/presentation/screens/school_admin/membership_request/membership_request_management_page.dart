import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/membership_request_management_bloc.dart';
import 'bloc/membership_request_management_event.dart';
import 'bloc/membership_request_management_state.dart';
import 'widgets/membership_sort_filter_control.dart';
import 'widgets/membership_view.dart';

class MembershipRequestManagementPage extends StatefulWidget {
  const MembershipRequestManagementPage({super.key});

  @override
  State<MembershipRequestManagementPage> createState() =>
      _MembershipRequestManagementPageState();
}

class _MembershipRequestManagementPageState
    extends State<MembershipRequestManagementPage> {
  final ScrollController _scrollController = ScrollController();

  static const Map<Map<String, String>, String> sortOptions = {
    {'name': 'asc'}: 'Tên (A-Z)',
    {'name': 'desc'}: 'Tên (Z-A)',
    {'code': 'asc'}: 'Mã (A-Z)',
    {'code': 'desc'}: 'Mã (Z-A)',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<MembershipRequestManagementBloc>().add(
      const LoadMembershipRequestsEvent(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<MembershipRequestManagementBloc>().state;
    if (_isBottom && state is MembershipRequestLoaded && !state.hasReachedMax) {
      context.read<MembershipRequestManagementBloc>().add(
        LoadMoreMembershipRequestsEvent(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    return _scrollController.offset >=
        (_scrollController.position.maxScrollExtent * 0.9);
  }

  void _onRefresh() {
    context.read<MembershipRequestManagementBloc>().add(
      RefreshMembershipRequestsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Quản lý yêu cầu thành viên',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: Icon(Icons.refresh_rounded),
            tooltip: "Tải lại danh sách",
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
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: MembershipSortFilterControl(
                      state: state,
                      sortOptions: sortOptions,
                    ),
                  ),
                  Expanded(
                    child: MembershipSortView(
                      state: state,
                      scrollController: _scrollController,
                      onRefresh: _onRefresh,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
