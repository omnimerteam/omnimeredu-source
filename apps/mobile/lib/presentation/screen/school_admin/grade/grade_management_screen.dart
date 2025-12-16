import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/grade_management_bloc.dart';
import 'bloc/grade_management_event.dart';
import 'bloc/grade_management_state.dart';
import 'widgets/grade_form_dialog.dart';
import 'widgets/grade_list_view.dart';
import 'widgets/grade_sort_controls.dart';

class GradeManagementScreen extends StatelessWidget {
  const GradeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradeManagementView();
  }
}

class GradeManagementView extends StatelessWidget {
  const GradeManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý khối'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            tooltip: "Tải lại danh sách",
            onPressed: () {
              context.read<GradeManagementBloc>().add(const LoadGradesEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocListener<GradeManagementBloc, GradeManagementState>(
        listenWhen: (previous, current) {
          if (previous is GradeManagementLoaded &&
              current is GradeManagementLoaded) {
            return previous.isFormVisible != current.isFormVisible;
          }
          return false;
        },
        listener: (context, state) {
          if (state is GradeManagementLoaded && state.isFormVisible) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: context.read<GradeManagementBloc>(),
                  child: GradeFormDialog(gradeToEdit: state.gradeToEdit),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GradeSortControls(),
                    SizedBox(height: 16.h),

                    // Title + Create button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Danh sách khối',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                        ),

                        _buildCreateButton(context, Theme.of(context)),
                      ],
                    ),

                    SizedBox(height: 12.h),
                    const GradeListView(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(10.r),
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
          context.read<GradeManagementBloc>().add(const ShowCreateFormEvent());
        },
        icon: Icon(Icons.add_rounded, size: 18.sp),
        label: Text(
          'Tạo khối mới',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          minimumSize: Size(140.w, 40.h),
        ),
      ),
    );
  }
}
