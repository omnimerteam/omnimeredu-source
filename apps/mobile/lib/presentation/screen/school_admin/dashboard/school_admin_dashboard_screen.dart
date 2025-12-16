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
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: Colors.blue,
                      size: 48.w,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Chào mừng School Admin',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Bạn chưa thiết lập trường học. Hãy bắt đầu bằng cách tạo trường mới.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              const SchoolAdminDashboardQuickAccess(highlightSchool: true),
            ],
          ),
        ),
      );
    }

    // Nếu có dữ liệu => hiển thị dashboard bình thường
    return Scaffold(
      appBar: AppBar(
        title: const Text("School Admin"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 80.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardQuickOverview(overview: data!.overview),
            SizedBox(height: 24.h),
            const SchoolAdminDashboardQuickAccess(),
          ],
        ),
      ),
    );
  }
}
