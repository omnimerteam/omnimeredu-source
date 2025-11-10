import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/school/school_data_entity.dart';
import 'bloc/school_data_schooladmin_bloc.dart';
import 'bloc/school_data_schooladmin_event.dart';
import 'bloc/school_data_schooladmin_state.dart';
import 'widgets/school_data_widget.dart';
import 'widgets/school_empty_state_widget.dart';
import 'widgets/school_error_state_widget.dart';
import 'widgets/school_form_dialog.dart';
import 'widgets/school_skeleton_loader.dart';
import '../../../../core/theme/app_colors.dart';

class SchoolDataSchoolAdminScreen extends StatelessWidget {
  const SchoolDataSchoolAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Không còn BlocProvider ở đây
    return const _SchoolDataSchoolAdminScreenView();
  }
}

class _SchoolDataSchoolAdminScreenView extends StatelessWidget {
  const _SchoolDataSchoolAdminScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(
        Theme.of(context).brightness == Brightness.dark,
      ),
      appBar: AppBar(
        title: const Text(
          'Quản lý thông tin trường',
          style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SchoolDataSchoolAdminBloc>().add(LoadSchoolDataAdmin());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<SchoolDataSchoolAdminBloc, SchoolDataAdminState>(
            builder: (context, state) {
              if (state is SchoolDataAdminLoading) {
                return const SchoolSkeletonLoader();
              } else if (state is SchoolDataAdminEmpty) {
                return SchoolEmptyState(
                  onCreatePressed: () => _showFormDialog(context),
                );
              } else if (state is SchoolDataAdminLoaded) {
                return SchoolDataWidget(
                  school: state.school,
                  onEditPressed: () => _showFormDialog(context, state.school),
                  onDeletePressed: () => _confirmDelete(context),
                );
              } else if (state is SchoolDataAdminError) {
                return SchoolErrorState(
                  message: state.message,
                  onRetryPressed: () => context
                      .read<SchoolDataSchoolAdminBloc>()
                      .add(LoadSchoolDataAdmin()),
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
          final bloc = context.read<SchoolDataSchoolAdminBloc>();
          if (school != null) {
            bloc.add(UpdateSchoolDataAdminEvent(schoolData));
          } else {
            bloc.add(CreateSchoolDataAdminEvent(schoolData));
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Xác nhận xóa'),
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
              gradient: LinearGradient(colors: AppColors.errorGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.read<SchoolDataSchoolAdminBloc>().add(
                  DeleteSchoolDataAdminEvent(),
                );
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
