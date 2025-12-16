import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/button/app_button.dart';
import '../../../../common/widgets/skeleton/common_skeleton.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';
import 'class_list_item.dart';

class ClassListView extends StatelessWidget {
  const ClassListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        if (state is ClassManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ClassManagementError) {
          return Center(child: Text(state.message));
        }

        if (state is ClassManagementLoaded) {
          if (state.classes.isEmpty) {
            return const Center(child: Text('Chưa có lớp học nào'));
          }
          return _buildClassList(context, state);
        }

        if (state is ClassManagementLoadingMore) {
          return _buildClassListWithLoadingMore(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildClassList(BuildContext context, ClassManagementLoaded state) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.classes.length,
          itemBuilder: (context, index) {
            return ClassListItem(classDetail: state.classes[index]);
          },
        ),
        if (!state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              onPressed: () {
                context.read<ClassManagementBloc>().add(LoadMoreClassesEvent());
              },
              text: 'Tải thêm',
            ),
          ),
      ],
    );
  }

  Widget _buildClassListWithLoadingMore(
    BuildContext context,
    ClassManagementLoadingMore state,
  ) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.classes.length,
          itemBuilder: (context, index) {
            return ClassListItem(classDetail: state.classes[index]);
          },
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
