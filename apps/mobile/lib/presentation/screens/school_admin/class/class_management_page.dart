import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';
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
    // Không còn BlocProvider ở đây
    return const ClassManagementView();
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
        listenWhen: (previous, current) =>
            previous.isFormVisible != current.isFormVisible,
        listener: (context, state) {
          if (state.isFormVisible) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: context.read<ClassManagementBloc>(),
                  child: ClassFormDialog(classToEdit: state.classToEdit),
                );
              },
            );
          }
        },
        child: Column(
          children: [
            // Nội dung chính cuộn được
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionTitle(title: 'Danh sách lớp học'),
                    SizedBox(height: 24),
                    ClassSortControls(),
                    SizedBox(height: 24),
                    ClassListView(),
                  ],
                ),
              ),
            ),

            // Thanh phân trang dính dưới
            BlocBuilder<ClassManagementBloc, ClassManagementState>(
              builder: (context, state) {
                if (state.classes.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: const ClassPagination(),
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
