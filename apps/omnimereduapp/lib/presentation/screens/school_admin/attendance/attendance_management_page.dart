import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/attendance_management_bloc.dart';
import 'bloc/attendance_management_event.dart';
import 'widgets/attendance_filter_control.dart';
import 'widgets/attendance_list_view.dart';
import '../../../widgets/text/section_title.dart';
import 'widgets/attendance_create_button.dart';

class AttendanceManagementPage extends StatelessWidget {
  const AttendanceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AttendanceManagementView();
  }
}

class AttendanceManagementView extends StatelessWidget {
  const AttendanceManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý điểm danh'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onBackground,
        actions: [
          IconButton(
            tooltip: "Tải lại danh sách",
            onPressed: () {
              context.read<AttendanceManagementBloc>().add(
                const LoadAttendancesEvent(),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AttendanceFilterControl(),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle(title: 'Danh sách điểm danh'),
                      const AttendanceCreateButton(), // ✅ Gọi widget mới
                    ],
                  ),
                  const SizedBox(height: 12),

                  const AttendanceListView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
