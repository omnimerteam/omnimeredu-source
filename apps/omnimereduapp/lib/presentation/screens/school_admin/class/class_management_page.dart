// Fixed class_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../../../core/bloc/authentication/authentication_state.dart';
import '../../common/grade_select/cubit/grade_select_cubit.dart';
import 'bloc/class_management_event.dart';
import '../../../widgets/text/section_title.dart';
import '../../../../injection_container.dart';
import 'bloc/class_management_bloc.dart';
import 'bloc/class_management_state.dart';
import 'widgets/class_sort_controls.dart';
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
        actions: [
          IconButton(
            tooltip: "Tải lại danh sách",
            onPressed: () {
              context.read<ClassManagementBloc>().add(LoadClassesEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClassSortControls(),
                    const SizedBox(height: 16),

                    // Title + Create button cùng 1 dòng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'Danh sách lớp học'),

                        // Chỉ hiển thị khi user là SchoolAdmin
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, state) {
                            if (state is AuthenticationAuthenticated &&
                                state.user.roleName == "SchoolAdmin") {
                              return _buildCreateButton(
                                context,
                                Theme.of(context),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const ClassListView(),
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
          context.read<ClassManagementBloc>().add(ShowCreateFormEvent());
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Tạo lớp',
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
          minimumSize: const Size(140, 40), // Đảm bảo button có size tối thiểu
        ),
      ),
    );
  }
}
