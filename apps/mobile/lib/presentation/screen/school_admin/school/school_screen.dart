import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'bloc/school_bloc.dart';
import 'bloc/school_event.dart';
import 'bloc/school_state.dart';
import 'widgets/school_data_view.dart';
import 'widgets/school_empty_state.dart';
import 'widgets/school_error_state.dart';
import 'widgets/school_form_dialog.dart';
import 'widgets/school_skeleton_loader.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/injection_container.dart' as di;

class SchoolAdminSchoolScreen extends StatelessWidget {
  const SchoolAdminSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SchoolAdminSchoolBloc>()..add(LoadSchoolDetail()),
      child: const _SchoolAdminSchoolScreenView(),
    );
  }
}

class _SchoolAdminSchoolScreenView extends StatelessWidget {
  const _SchoolAdminSchoolScreenView();

  @override
  Widget build(BuildContext context) {
    // We can also access theme from context here
    // final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(
        Theme.of(context).brightness == Brightness.dark,
      ),
      appBar: AppBar(
        title: Text(
          'Quản lý thông tin trường',
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SchoolAdminSchoolBloc>().add(LoadSchoolDetail());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          child: BlocBuilder<SchoolAdminSchoolBloc, SchoolState>(
            builder: (context, state) {
              if (state is SchoolLoading) {
                return const SchoolSkeletonLoader();
              } else if (state is SchoolEmpty) {
                return SchoolEmptyState(
                  onCreatePressed: () => _showFormDialog(context),
                );
              } else if (state is SchoolLoaded) {
                return SchoolDataView(
                  school: state.school,
                  onEditPressed: () => _showFormDialog(context, state.school),
                  onDeletePressed: () => _confirmDelete(context),
                );
              } else if (state is SchoolError) {
                return SchoolErrorState(
                  message: state.message,
                  onRetryPressed: () => context
                      .read<SchoolAdminSchoolBloc>()
                      .add(LoadSchoolDetail()),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  void _showFormDialog(BuildContext context, [SchoolDataEntity? school]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SchoolFormDialog(
        school: school,
        onSubmit: (schoolData) {
          final bloc = context.read<SchoolAdminSchoolBloc>();
          if (school != null) {
            bloc.add(UpdateSchool(schoolData));
          } else {
            bloc.add(CreateSchool(schoolData));
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: AppColors.warning),
            SizedBox(width: 8.w),
            const Text('Xác nhận xóa'),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa thông tin trường này không?\n\nHành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.errorGradient),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.read<SchoolAdminSchoolBloc>().add(DeleteSchool());
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
