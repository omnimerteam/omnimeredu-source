import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/grade_management_bloc.dart';
import 'bloc/grade_management_event.dart';
import 'bloc/grade_management_state.dart';
import 'widgets/grade_form_dialog.dart';
import 'widgets/grade_list_view.dart';
import 'widgets/grade_sort_controls.dart';
import 'widgets/grade_screen_header.dart';

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
                    const GradeScreenHeader(),
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
}
