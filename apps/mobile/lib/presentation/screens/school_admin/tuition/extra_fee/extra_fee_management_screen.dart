import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/grade_select/cubit/grade_select_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/student_selector/cubit/student_selector_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/widgets/extra_fee_detail_bottom_sheet.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/widgets/extra_fee_form_dialog.dart';

import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/widgets/extra_fee_list_view.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/widgets/extra_fee_sort_control.dart';

import 'package:flutter_ios_android_platforms/presentation/widgets/common/action_snack_bar.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';

class ExtraFeeManagementScreen extends StatelessWidget {
  const ExtraFeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    String schoolId = '';
    if (authState is AuthenticationAuthenticated) {
      schoolId = authState.user.schoolId ?? '';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quản lý phí phụ'),
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
              context.read<ExtraFeeManagementBloc>().add(LoadExtraFeeEvent());
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ExtraFeeManagementBloc>(),
                  ),
                  BlocProvider.value(value: context.read<ClassSelectorBloc>()),
                  BlocProvider.value(value: context.read<GradeSelectCubit>()),
                  BlocProvider.value(
                    value: context.read<StudentSelectorCubit>(),
                  ),
                ],
                child: ExtraFeeFormDialog(extraFee: null, schoolId: schoolId),
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm phí phụ'),
      ),
      body: MultiBlocListener(
        listeners: [
          // Bottom sheet for extra fee details
          BlocListener<ExtraFeeManagementBloc, ExtraFeeManagementState>(
            listenWhen: (previous, current) =>
                previous is ExtraFeeManagementLoaded &&
                current is ExtraFeeManagementLoaded &&
                previous.isDetailsVisible != current.isDetailsVisible,
            listener: (context, state) {
              if (state is ExtraFeeManagementLoaded && state.isDetailsVisible) {
                showExtraFeeDetailsBottomSheet(context);
              }
            },
          ),

          // Success/error snackbars
          BlocListener<ExtraFeeManagementBloc, ExtraFeeManagementState>(
            listenWhen: (previous, current) {
              if (current is ExtraFeeManagementLoaded) {
                final prev = previous is ExtraFeeManagementLoaded
                    ? previous
                    : null;
                return current.lastActionSuccess != prev?.lastActionSuccess ||
                    current.message != prev?.message ||
                    current.status != prev?.status;
              }
              return false;
            },
            listener: (context, state) {
              if (state is ExtraFeeManagementLoaded) {
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
                    const ExtraFeeSortControls(),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Danh sách phí phụ'),
                    const SizedBox(height: 12),
                    const ExtraFeeListView(),
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

Future<void> showExtraFeeDetailsBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ExtraFeeManagementBloc>(),
        child: const ExtraFeeDetailsBottomSheet(),
      );
    },
  );

  // Khi đóng bottom sheet (kéo xuống hoặc bấm close)
  context.read<ExtraFeeManagementBloc>().add(HideExtraFeeDetailsEvent());
}
