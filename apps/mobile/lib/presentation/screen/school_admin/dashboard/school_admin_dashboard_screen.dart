import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'widgets/dashboard_quick_overview.dart';
import 'widgets/school_admin_dashboard_quick_access.dart';

class SchoolAdminDashboardScreen extends StatelessWidget {
  final SchoolAdminDashboardDataEntity? data;
  final bool isLoading;
  final String roleName;

  const SchoolAdminDashboardScreen({
    super.key,
    this.data,
    this.isLoading = false,
    required this.roleName,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu loading
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Nếu load xong mà chưa có dữ liệu => hiển thị hướng dẫn
    if (!isLoading && data == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.blue,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Chưa có trường nào được tạo',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(left: 28.w),
                      child: Text(
                        'Vui lòng tạo trường đầu tiên để bắt đầu quản lý.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.black.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              const SchoolAdminDashboardQuickAccess(highlightSchool: true),
            ],
          ),
        ),
      );
    }

    // Nếu có dữ liệu => hiển thị dashboard bình thường
    return Scaffold(
      appBar: AppBar(title: const Text("School Admin")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardQuickOverview(overview: data!.overview),
            SizedBox(height: 24.h),
            // AttendanceChart removed for now (missing dependencies)
            SizedBox(height: 24.h),
            const SchoolAdminDashboardQuickAccess(),
          ],
        ),
      ),
    );
  }
}
