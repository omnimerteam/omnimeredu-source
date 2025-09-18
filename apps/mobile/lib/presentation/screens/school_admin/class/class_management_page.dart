// Fixed class_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/grade_select/grade_select_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'bloc/class_management_bloc.dart';
import 'bloc/class_management_state.dart';
import 'widgets/class_sort_controls.dart';
import 'widgets/class_pagination.dart';
import 'widgets/class_list_view.dart';
import 'widgets/class_form_dialog.dart';

class ClassManagementPage extends StatelessWidget {
  const ClassManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create GradeSelectCubit and load grades immediately
    return BlocProvider<GradeSelectCubit>(
      create: (context) {
        final cubit = sl<GradeSelectCubit>();
        cubit.loadGrades(); // Load grades immediately
        return cubit;
      },
      child: const ClassManagementView(),
    );
  }
}

class ClassManagementView extends StatelessWidget {
  const ClassManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý lớp học'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: BlocListener<ClassManagementBloc, ClassManagementState>(
        listenWhen: (previous, current) {
          if (previous is ClassManagementLoaded &&
              current is ClassManagementLoaded) {
            return previous.isFormVisible != current.isFormVisible;
          }
          return false;
        },
        listener: (context, state) {
          if (state is ClassManagementLoaded && state.isFormVisible) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return MultiBlocProvider(
                  providers: [
                    // Provide ClassManagementBloc to the dialog
                    BlocProvider.value(
                      value: context.read<ClassManagementBloc>(),
                    ),
                    // Provide GradeSelectCubit to the dialog
                    BlocProvider.value(value: context.read<GradeSelectCubit>()),
                  ],
                  child: ClassFormDialog(classToEdit: state.classToEdit),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Danh sách lớp học'),
                    SizedBox(height: 24),
                    ClassSortControls(),
                    SizedBox(height: 24),
                    ClassListView(),
                  ],
                ),
              ),
            ),

            // Sticky pagination bar at bottom (Optional - can be removed if using load more)
            BlocBuilder<ClassManagementBloc, ClassManagementState>(
              builder: (context, state) {
                if (state is ClassManagementLoaded &&
                    state.classes.isNotEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: ClassPagination(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
