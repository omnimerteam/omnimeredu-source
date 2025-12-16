import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../injection_container.dart';
import '../../../common/grade_select/cubit/grade_select_cubit.dart';
import '../../../common/widgets/button/app_button.dart';
import 'bloc/class_management_bloc.dart';
import 'bloc/class_management_event.dart';
import 'bloc/class_management_state.dart';
import 'widgets/class_list_view.dart';
import 'widgets/class_sort_controls.dart';
import 'widgets/class_form_dialog.dart';

class ClassManagementScreen extends StatelessWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClassManagementBloc>(
          create: (context) =>
              sl<ClassManagementBloc>()..add(const LoadClassesEvent()),
        ),
        BlocProvider<GradeSelectCubit>(
          create: (context) => sl<GradeSelectCubit>()..loadGrades(),
        ),
      ],
      child: BlocListener<ClassManagementBloc, ClassManagementState>(
        listener: (context, state) {
          if (state is ClassManagementLoaded && state.isFormVisible) {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<ClassManagementBloc>(),
                child: ClassFormDialog(classToEdit: state.classToEdit),
              ),
            ).then((_) {
              // Ensure form hidden if dialog dismissed manually
              context.read<ClassManagementBloc>().add(HideFormEvent());
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý lớp học'),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // We need context here, but RefreshIndicator doesn't provide it easily outside.
              // We can wrap body in Builder or just assume context is valid if using BlocProvider above
            },
            child: BlocBuilder<ClassManagementBloc, ClassManagementState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ClassManagementBloc>().add(
                      RefreshClassesEvent(),
                    );
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        const ClassSortControls(), // Filters
                        SizedBox(height: 16.h),
                        // Create Button? Or FAB?
                        // User request UI refactor.
                        // Adding Create Button at top or bottom?
                        // Usually FAB is best.
                        const ClassListView(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  context.read<ClassManagementBloc>().add(
                    ShowCreateFormEvent(),
                  );
                },
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}
