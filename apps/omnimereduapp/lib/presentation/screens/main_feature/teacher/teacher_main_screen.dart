import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnimereduapp/presentation/screens/main_feature/teacher/widgets/attendance_action_dialog.dart';
import 'package:omnimereduapp/presentation/screens/main_feature/teacher/widgets/attendance_loading_state.dart';
import '../../../../domain/entities/view_model/attendance_record_view_entity.dart';
import '../../common/class_selector/bloc/class_selector_bloc.dart';
import '../../common/class_selector/bloc/class_selector_state.dart';
import 'bloc/teacher_attendance_bloc.dart';
import 'bloc/teacher_attendance_event.dart';
import 'bloc/teacher_attendance_state.dart';
import 'widgets/attendance_dialog.dart';
import 'widgets/attendance_stats_card.dart';
import 'widgets/class_and_date_selector.dart';
import 'widgets/attendance_table_section.dart';
import '../../../widgets/text_field/search_text_field.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final String schoolId;

  const TeacherAttendanceScreen({super.key, required this.schoolId});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildHeader(context),
          const SizedBox(height: 24),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Bảng điểm danh',
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<TeacherAttendanceBloc, TeacherAttendanceState>(
      listener: _handleStateChanges,
      builder: (context, attendanceState) {
        return BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
          builder: (context, classState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassAndDateSelector(attendanceState),
                  const SizedBox(height: 16),
                  _buildStatsCard(attendanceState),
                  const SizedBox(height: 16),
                  _buildSearchField(),
                  const SizedBox(height: 16),
                  _buildStudentTable(attendanceState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClassAndDateSelector(TeacherAttendanceState state) {
    return ClassAndDateSelector(
      key: ValueKey(state.selectedClassId),
      schoolId: widget.schoolId,
      gradeGroup: null,
      initialClassId: state.selectedClassId,
      initialDate: state.selectedDate,
      isLoading:
          state.status == AttendanceStatus.initializing ||
          state.status == AttendanceStatus.deleting,
      hasAttendance: state.attendanceRecord != null,
      onClassChanged: _handleClassChanged,
      onDateChanged: _handleDateChanged,
      onRefresh: () => _handleRefresh(state),
      onNewOrDelete: () => _handleCreateOrDelete(state),
    );
  }

  Widget _buildStatsCard(TeacherAttendanceState state) {
    if (state.status == AttendanceStatus.loading) {
      return const AttendanceStatsLoading();
    }
    return AttendanceStatsCard(stats: state.attendanceStats);
  }

  Widget _buildSearchField() {
    return SearchTextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      hintText: "Nhập tên học sinh",
      isFocused: _isSearchFocused,
      onChanged: (query) {
        context.read<TeacherAttendanceBloc>().add(SearchStudents(query));
      },
    );
  }

  Widget _buildStudentTable(TeacherAttendanceState state) {
    return AttendanceTableSection(
      state: state,
      onEditStudent: _showAttendanceDialog,
      onExportData: _handleExportData,
      onCreateAttendance: () => _handleCreateOrDelete(state),
    );
  }

  // ========== Event Handlers ==========

  void _handleStateChanges(BuildContext context, TeacherAttendanceState state) {
    _showSnackBarForStatus(context, state);
  }

  void _showSnackBarForStatus(
    BuildContext context,
    TeacherAttendanceState state,
  ) {
    String? message;
    Color? backgroundColor;

    switch (state.status) {
      case AttendanceStatus.initializeSuccess:
        message = 'Tạo bảng điểm danh thành công';
        backgroundColor = Colors.green;
        break;
      case AttendanceStatus.initializeFailure:
        message = state.errorMessage ?? 'Không thể tạo bảng điểm danh';
        backgroundColor = Colors.red;
        break;
      case AttendanceStatus.deleteSuccess:
        message = 'Xóa bảng điểm danh thành công';
        backgroundColor = Colors.green;
        break;
      case AttendanceStatus.deleteFailure:
        message = state.errorMessage ?? 'Không thể xóa bảng điểm danh';
        backgroundColor = Colors.red;
        break;
      case AttendanceStatus.failure:
        message = state.errorMessage ?? 'Đã xảy ra lỗi';
        backgroundColor = Colors.red;
        break;
      default:
        return;
    }

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleClassChanged(dynamic clazz) {
    if (clazz != null) {
      context.read<TeacherAttendanceBloc>().add(ChangeSelectedClass(clazz.id));
    }
  }

  void _handleDateChanged(DateTime date) {
    context.read<TeacherAttendanceBloc>().add(ChangeSelectedDate(date));
  }

  void _handleRefresh(TeacherAttendanceState state) {
    if (state.selectedClassId != null) {
      context.read<TeacherAttendanceBloc>().add(
        RefreshAttendanceRecord(
          date: state.selectedDate,
          classId: state.selectedClassId!,
        ),
      );
    }
  }

  void _handleCreateOrDelete(TeacherAttendanceState state) {
    if (state.selectedClassId == null) {
      _showSelectClassWarning();
      return;
    }

    AttendanceDialogHelper.showCreateOrDeleteDialog(
      context: context,
      hasAttendance: state.attendanceRecord != null,
      selectedDate: state.selectedDate,
      onCreateConfirm: () => _executeCreate(state),
      onDeleteConfirm: () => _executeDelete(state),
    );
  }

  void _showSelectClassWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vui lòng chọn lớp học'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _executeCreate(TeacherAttendanceState state) {
    context.read<TeacherAttendanceBloc>().add(
      InitializeAttendance(
        classId: state.selectedClassId!,
        schoolId: widget.schoolId,
        date: state.selectedDate,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang tạo bảng điểm danh...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _executeDelete(TeacherAttendanceState state) {
    context.read<TeacherAttendanceBloc>().add(
      DeleteAttendance(state.attendanceRecord!.id),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang xóa bảng điểm danh...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleExportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng xuất dữ liệu đang được phát triển'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAttendanceDialog(StudentAttendanceEntity student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AttendanceDialog(
          student: student,
          onUpdate: (status, note) {
            context.read<TeacherAttendanceBloc>().add(
              UpdateStudentStatus(
                recordId: student.detailRecordId,
                status: status,
                note: note,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật điểm danh thành công'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }
}
