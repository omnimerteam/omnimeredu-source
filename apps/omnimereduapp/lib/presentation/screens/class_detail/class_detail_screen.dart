import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/class_detail_cubit.dart';
import 'cubit/class_detail_state.dart';
import 'widgets/class_detail_skeleton.dart';
import 'widgets/class_info_card.dart';
import 'widgets/student_list.dart';
import '../common/class_member_dialog/bloc/class_member_event.dart';
import '../common/class_member_dialog/class_member_dialog_helper.dart';
import '../../widgets/text_field/search_text_field.dart';

class ClassDetailScreen extends StatefulWidget {
  final String classId;

  const ClassDetailScreen({super.key, required this.classId});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Load class detail when screen initializes
    context.read<ClassDetailCubit>().loadClassDetail(widget.classId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClassDetailCubit, ClassDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state is ClassDetailLoaded
                ? Text('${state.classDetail.name} - ${state.classDetail.code}')
                : const Text('Chi tiết lớp học'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<ClassDetailCubit>().refreshClassDetail();
                },
              ),
            ],
          ),
          body: _buildBody(state, theme),
        );
      },
    );
  }

  Widget _buildBody(ClassDetailState state, ThemeData theme) {
    if (state is ClassDetailLoading) {
      return const ClassDetailSkeleton();
    }

    if (state is ClassDetailError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Đã xảy ra lỗi',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ClassDetailCubit>().loadClassDetail(
                    widget.classId,
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is ClassDetailLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<ClassDetailCubit>().refreshClassDetail();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Info Card
              ClassInfoCard(classDetail: state.classDetail),
              const SizedBox(height: 16),

              // Search Field
              SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: 'Tìm kiếm học sinh...',
                isFocused: _searchFocusNode.hasFocus,
                onChanged: (value) {
                  context.read<ClassDetailCubit>().searchStudents(value);
                },
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ClassDetailCubit>().searchStudents('');
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 16),

              // Student List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách học sinh',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Nút thêm học sinh
                      IconButton(
                        tooltip: 'Thêm học sinh vào lớp',
                        icon: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () async {
                          final result = await showClassMemberDialog(
                            context: context,
                            schoolId: state.classDetail.school!.id,
                            initialClassId: state.classDetail.id,
                            initialMode: ClassMemberMode.add,
                            isTeacher: false,
                          );

                          if (result == true) {
                            // Làm mới dữ liệu sau khi thêm học sinh
                            context
                                .read<ClassDetailCubit>()
                                .refreshClassDetail();
                          }
                        },
                      ),

                      // Thống kê số lượng học sinh
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${state.filteredStudents.length} học sinh',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Student List
              StudentListWidget(students: state.filteredStudents),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
