import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../common/class_selector/bloc/class_selector_bloc.dart';
import 'bloc/student_management_bloc.dart';
import 'bloc/student_management_event.dart';
import 'bloc/student_management_state.dart';
import 'widgets/student_detail_bottom_sheet.dart';
import 'widgets/student_sort_control.dart';
import '../../../widgets/text/section_title.dart';
import 'widgets/student_list_view.dart';
import 'widgets/student_form_dialog.dart';

class StudentManagementPage extends StatelessWidget {
  const StudentManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Không cần BlocProvider ở đây nữa vì đã khởi tạo từ route
    return const StudentManagementView();
  }
}

class StudentManagementView extends StatelessWidget {
  const StudentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý học sinh'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            tooltip: "Tải lại danh sách",
            onPressed: () {
              context.read<StudentManagementBloc>().add(LoadStudentsEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),

      body: MultiBlocListener(
        listeners: [
          // Form dialog
          BlocListener<StudentManagementBloc, StudentManagementState>(
            listenWhen: (previous, current) =>
                previous is StudentManagementLoaded &&
                current is StudentManagementLoaded &&
                previous.isFormVisible != current.isFormVisible,
            listener: (context, state) {
              if (state is StudentManagementLoaded && state.isFormVisible) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<StudentManagementBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<AuthenticationBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<ClassSelectorBloc>(),
                        ),
                      ],
                      child: StudentFormDialog(
                        studentToEdit: state.studentToEdit,
                      ),
                    );
                  },
                );
              }
            },
          ),

          // Bottom sheet
          BlocListener<StudentManagementBloc, StudentManagementState>(
            listenWhen: (previous, current) =>
                previous is StudentManagementLoaded &&
                current is StudentManagementLoaded &&
                previous.isDetailsVisible != current.isDetailsVisible,
            listener: (context, state) {
              if (state is StudentManagementLoaded && state.isDetailsVisible) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (bottomSheetContext) {
                    return BlocProvider.value(
                      value: context.read<StudentManagementBloc>(),
                      child: const StudentDetailsBottomSheet(),
                    );
                  },
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort and Filter
                    MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<StudentManagementBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<ClassSelectorBloc>(),
                        ),
                      ],
                      child: StudentSortControls(),
                    ),

                    const SizedBox(height: 16),

                    // Title + Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'Danh sách học sinh'),

                        _buildCreateButton(context, Theme.of(context)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // List
                    const StudentListView(),
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
          context.read<StudentManagementBloc>().add(ShowCreateFormEvent());
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Thêm học sinh',
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
