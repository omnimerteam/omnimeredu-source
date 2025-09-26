import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/role/bloc/role_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/widgets/assignment_dialog.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/widgets/personnel_details_bottom_sheet.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/widgets/personnel_list_view.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/widgets/personnel_sort_controls.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/common/action_snack_bar.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';

class PersonnelManagementScreen extends StatelessWidget {
  const PersonnelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý nhân sự'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            tooltip: "Tải lại danh sách",
            onPressed: () {
              context.read<PersonnelManagementBloc>().add(LoadPersonnelEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          // Bottom sheet for personnel details
          BlocListener<PersonnelManagementBloc, PersonnelManagementState>(
            listenWhen: (previous, current) =>
                previous is PersonnelManagementLoaded &&
                current is PersonnelManagementLoaded &&
                previous.isDetailsVisible != current.isDetailsVisible,
            listener: (context, state) {
              if (state is PersonnelManagementLoaded &&
                  state.isDetailsVisible) {
                showPersonnelDetailsBottomSheet(context);
              }
            },
          ),

          // Assignment dialog
          BlocListener<PersonnelManagementBloc, PersonnelManagementState>(
            listenWhen: (previous, current) =>
                previous is PersonnelManagementLoaded &&
                current is PersonnelManagementLoaded &&
                previous.isAssignmentDialogVisible !=
                    current.isAssignmentDialogVisible,
            listener: (context, state) {
              if (state is PersonnelManagementLoaded &&
                  state.isAssignmentDialogVisible &&
                  state.selectedPersonnelForAssignment != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<PersonnelManagementBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<AuthenticationBloc>(),
                        ),
                        BlocProvider.value(value: context.read<ClassBloc>()),
                        BlocProvider.value(value: context.read<RoleBloc>()),
                      ],
                      child: AssignmentDialog(
                        personnel: state.selectedPersonnelForAssignment!,
                      ),
                    );
                  },
                );
              }
            },
          ),

          // Success/error snackbars for all use cases
          BlocListener<PersonnelManagementBloc, PersonnelManagementState>(
            listenWhen: (previous, current) {
              if (current is PersonnelManagementLoaded) {
                final prev = previous is PersonnelManagementLoaded
                    ? previous
                    : null;
                return current.lastActionSuccess != prev?.lastActionSuccess ||
                    current.message != prev?.message ||
                    current.assignmentErrorMessage !=
                        prev?.assignmentErrorMessage;
              }
              return false;
            },
            listener: (context, state) {
              if (state is PersonnelManagementLoaded) {
                showActionSnackBar(
                  context: context,
                  message: state.message,
                  lastActionSuccess: state.lastActionSuccess,
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
                          value: context.read<PersonnelManagementBloc>(),
                        ),
                        BlocProvider.value(value: context.read<RoleBloc>()),
                      ],
                      child: const PersonnelSortControls(),
                    ),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Danh sách nhân sự'),
                    const SizedBox(height: 12),
                    const PersonnelListView(),
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

Future<void> showPersonnelDetailsBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<PersonnelManagementBloc>(),
        child: const PersonnelDetailsBottomSheet(),
      );
    },
  );

  // Khi đóng bottom sheet (kéo xuống hoặc bấm close)
  context.read<PersonnelManagementBloc>().add(HidePersonnelDetailsEvent());
}
