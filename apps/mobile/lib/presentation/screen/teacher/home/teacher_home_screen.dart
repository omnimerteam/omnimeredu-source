import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routing/route_config.dart';

import '../../../common/blocs/auth_bloc/auth_bloc.dart';
import 'bloc/teacher_attendance_bloc.dart';
import 'bloc/teacher_attendance_event.dart';
import 'bloc/teacher_attendance_state.dart';
import 'widgets/attendance_action_dialog.dart';
import 'widgets/attendance_dialog.dart';
import 'widgets/attendance_stats_card.dart';
import 'widgets/attendance_table_section.dart';
import 'widgets/class_and_date_selector.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  // Placeholder for classes. In real app, fetch this from ClassBloc/Repository
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get authState early to avoid issues in BlocProvider create
    final authState = context.read<AuthBloc>().state;
    String? schoolId;
    if (authState is AuthAuthenticated) {
      schoolId = authState.user.schoolId;
    }

    // If no schoolId, show an error state
    if (schoolId == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Không tìm thấy thông tin trường học',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Vui lòng đăng nhập lại',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) {
        final bloc = GetIt.I<TeacherAttendanceBloc>();
        bloc.add(LoadClasses(schoolId!));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bảng điểm danh',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 20.sp,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<TeacherAttendanceBloc, TeacherAttendanceState>(
      listener: (context, state) {
        if (state.status == AttendanceStatus.initializeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo điểm danh thành công'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == AttendanceStatus.deleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa điểm danh thành công'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // Retrieve schoolId from AuthBloc
        final authState = context.read<AuthBloc>().state;
        String schoolId = '';
        if (authState is AuthAuthenticated && authState.user.schoolId != null) {
          schoolId = authState.user.schoolId!;
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          children: [
            ClassAndDateSelector(
              schoolId: schoolId,
              initialClassId: state.selectedClassId,
              initialDate: state.selectedDate,
              isLoading:
                  state.status == AttendanceStatus.initializing ||
                  state.status == AttendanceStatus.deleting,
              hasAttendance: state.attendanceRecord != null,
              classes: state.classes,
              onClassChanged: (id) {
                context.read<TeacherAttendanceBloc>().add(
                  ChangeSelectedClass(id),
                );
              },
              onDateChanged: (date) {
                context.read<TeacherAttendanceBloc>().add(
                  ChangeSelectedDate(date),
                );
              },
              onRefresh: () {
                if (state.selectedClassId != null) {
                  context.read<TeacherAttendanceBloc>().add(
                    RefreshAttendanceRecord(
                      date: state.selectedDate,
                      classId: state.selectedClassId!,
                    ),
                  );
                }
              },
              onNewOrDelete: () {
                if (state.selectedClassId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn lớp')),
                  );
                  return;
                }

                AttendanceActionDialog.showCreateOrDeleteDialog(
                  context: context,
                  hasAttendance: state.attendanceRecord != null,
                  selectedDate: state.selectedDate,
                  onCreateConfirm: () {
                    context.read<TeacherAttendanceBloc>().add(
                      InitializeAttendance(
                        classId: state.selectedClassId!,
                        schoolId: schoolId,
                        date: state.selectedDate,
                      ),
                    );
                  },
                  onDeleteConfirm: () {
                    if (state.attendanceRecord != null) {
                      context.read<TeacherAttendanceBloc>().add(
                        DeleteAttendance(state.attendanceRecord!.id),
                      );
                    }
                  },
                );
              },
              onQRAttendance: () {
                if (state.attendanceRecord != null) {
                  Navigator.pushNamed(
                    context,
                    RouteConfig.teacherQR,
                    arguments: {
                      'attendanceId': state.attendanceRecord!.id,
                      'className': state.attendanceRecord!.classInfo.name,
                      'date': state.selectedDate,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng tạo bảng điểm danh trước'),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
            AttendanceStatsCard(stats: state.attendanceStats),
            SizedBox(height: 16.h),
            AttendanceTableSection(
              state: state,
              onEditStudent: (student) {
                showDialog(
                  context: context,
                  builder: (_) => AttendanceDialog(
                    student: student,
                    onUpdate: (status, note) {
                      context.read<TeacherAttendanceBloc>().add(
                        UpdateStudentStatus(
                          recordId: student.detailRecordId,
                          status: status,
                          note: note,
                        ),
                      );
                    },
                  ),
                );
              },
              onExportData: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển')),
                );
              },
              onCreateAttendance: () {
                if (state.selectedClassId != null) {
                  context.read<TeacherAttendanceBloc>().add(
                    InitializeAttendance(
                      classId: state.selectedClassId!,
                      schoolId: schoolId,
                      date: state.selectedDate,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn lớp')),
                  );
                }
              },
            ),
            // Padding to ensure content is not hidden behind CurvedNavigationBar
            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}
