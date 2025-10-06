import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/widgets/attendance_filter_control.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/widgets/attendance_list_view.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý điểm danh'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
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
                  // Filter Controls
                  const AttendanceFilterControl(),

                  const SizedBox(height: 16),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle(title: 'Danh sách điểm danh'),
                      _buildCreateButton(context, Theme.of(context)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // List
                  const AttendanceListView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to create attendance page
          Navigator.pushNamed(context, '/school-admin/attendance/create');
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Tạo điểm danh',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(140, 40),
        ),
      ),
    );
  }
}
