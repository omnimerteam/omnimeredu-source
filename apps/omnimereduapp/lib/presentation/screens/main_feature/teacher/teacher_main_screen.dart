import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/view_model/attendance_record_view_entity.dart';
import '../../common/class_selector/bloc/class_selector_bloc.dart';
import '../../common/class_selector/bloc/class_selector_state.dart';
import 'bloc/teacher_attendance_bloc.dart';
import 'bloc/teacher_attendance_event.dart';
import 'bloc/teacher_attendance_state.dart';
import 'widgets/attendance_dialog.dart';
import 'widgets/attendance_stats_card.dart';
import 'widgets/class_and_date_selector.dart';
import 'widgets/student_attendance_table.dart';
import '../../../widgets/button/app_button.dart';
import '../../../widgets/skeleton/common_skeleton.dart';
import '../../../widgets/text_field/search_text_field.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final String schoolId; // 🔹 Thêm schoolId từ authentication

  const TeacherAttendanceScreen({super.key, required this.schoolId});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();

    // lắng nghe focus thay đổi
    searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Bảng điểm danh',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Bloc Consumer
          Expanded(
            child: BlocConsumer<TeacherAttendanceBloc, TeacherAttendanceState>(
              listener: (context, state) {
                // 🔹 Xử lý thông báo khi tạo attendance
                if (state.status == AttendanceStatus.initializeSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tạo bảng điểm danh thành công'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                if (state.status == AttendanceStatus.initializeFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? 'Không thể tạo bảng điểm danh',
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                if (state.status == AttendanceStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, attendanceState) {
                return BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
                  builder: (context, classState) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClassAndDateSelector(
                            key: ValueKey(attendanceState.selectedClassId),
                            schoolId: widget.schoolId,
                            gradeGroup: null,
                            initialClassId: attendanceState.selectedClassId,
                            initialDate: attendanceState.selectedDate,
                            isLoading:
                                attendanceState.status ==
                                AttendanceStatus
                                    .initializing, // 🔹 Truyền trạng thái loading
                            canCreate:
                                attendanceState.selectedClassId != null &&
                                attendanceState
                                    .filteredStudents
                                    .isEmpty, // 🔹 Chỉ cho tạo khi đã chọn lớp
                            onClassChanged: (clazz) {
                              if (clazz != null) {
                                context.read<TeacherAttendanceBloc>().add(
                                  ChangeSelectedClass(clazz.id),
                                );
                              }
                            },
                            onDateChanged: (date) {
                              context.read<TeacherAttendanceBloc>().add(
                                ChangeSelectedDate(date),
                              );
                            },
                            onRefresh: () {
                              if (attendanceState.selectedClassId != null) {
                                context.read<TeacherAttendanceBloc>().add(
                                  RefreshAttendanceRecord(
                                    date: attendanceState.selectedDate,
                                    classId: attendanceState.selectedClassId!,
                                  ),
                                );
                              }
                            },
                            onNewOrDelete: () {
                              // 🔹 Xử lý tạo attendance mới
                              _handleCreateOrDeleteAttendance(
                                context,
                                attendanceState,
                              );
                            },
                            hasAttendance:
                                attendanceState.attendanceRecord != null,
                          ),
                          const SizedBox(height: 16),

                          /// Stats Card
                          if (attendanceState.status ==
                              AttendanceStatus.loading)
                            _buildStatsLoading()
                          else
                            AttendanceStatsCard(
                              stats: attendanceState.attendanceStats,
                            ),
                          const SizedBox(height: 16),

                          /// Search bar
                          SearchTextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            hintText: "Nhập tên học sinh",
                            isFocused: isSearchFocused,
                            onChanged: (query) {
                              context.read<TeacherAttendanceBloc>().add(
                                SearchStudents(query),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          /// Student Table Section
                          _buildStudentTableSection(attendanceState),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateOrDeleteAttendance(
    BuildContext context,
    TeacherAttendanceState state,
  ) {
    final bloc = context.read<TeacherAttendanceBloc>();

    if (state.selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lớp học'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final hasAttendance = state.attendanceRecord != null;

    // 🔹 Nếu đã có bảng điểm danh → hỏi xóa
    if (hasAttendance) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Xóa bảng điểm danh'),
          content: Text(
            'Bảng điểm danh cho ngày '
            '${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year} '
            'đã tồn tại.\n\nBạn có chắc muốn xóa bảng điểm danh này không?',
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    text: 'Hủy',
                    type: AppButtonType.cancel,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      // 🔹 Gửi event xóa bảng điểm danh
                      bloc.add(DeleteAttendance(state.attendanceRecord!.id));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang xóa bảng điểm danh...'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    text: 'Xóa',
                    type: AppButtonType.danger,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // 🔹 Nếu chưa có bảng điểm danh → hỏi tạo mới
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Tạo bảng điểm danh'),
          content: Text(
            'Bạn có chắc muốn tạo bảng điểm danh cho ngày '
            '${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year}?',
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    text: 'Hủy',
                    type: AppButtonType.cancel,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      // 🔹 Gửi event tạo bảng điểm danh mới
                      bloc.add(
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
                    },
                    text: 'Tạo mới',
                    type: AppButtonType.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatsLoading() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (index) => const SkeletonBox(height: 20, width: 60),
        ),
      ),
    );
  }

  Widget _buildStudentTableSection(TeacherAttendanceState state) {
    // 🔹 Xử lý trạng thái initializing
    if (state.status == AttendanceStatus.initializing) {
      return _buildInitializingState();
    }

    if (state.status == AttendanceStatus.loading) {
      return _buildTableLoading();
    }

    // 🔹 Hiển thị message khi chưa có attendance record
    if (state.status == AttendanceStatus.initial &&
        state.attendanceRecord == null &&
        state.selectedClassId != null) {
      return _buildNoAttendanceState(state);
    }

    if (state.status == AttendanceStatus.initial) {
      return _buildEmptyState('Vui lòng chọn lớp và ngày để xem điểm danh');
    }

    if (state.attendanceRecord == null ||
        state.attendanceRecord!.students == null) {
      return _buildEmptyState('Không có dữ liệu học sinh');
    }

    return StudentAttendanceTable(
      students: state.filteredStudents,
      onEditPressed: (student) {
        _showAttendanceDialog(context, student);
      },
      onExportData: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng xuất dữ liệu đang được phát triển'),
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }

  // 🔹 Widget hiển thị khi đang tạo attendance
  Widget _buildInitializingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Đang tạo bảng điểm danh...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng đợi trong giây lát',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔹 Widget hiển thị khi chưa có attendance record
  Widget _buildNoAttendanceState(TeacherAttendanceState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có bảng điểm danh',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có bảng điểm danh cho ngày '
            '${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _handleCreateOrDeleteAttendance(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Tạo bảng điểm danh'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableLoading() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(height: 20, width: 150),
              SkeletonBox(height: 40, width: 40, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: List.generate(
                  6,
                  (i) => const Flexible(
                    fit: FlexFit.loose, // 👈 thay Expanded
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: SkeletonBox(height: 40),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDialog(
    BuildContext context,
    StudentAttendanceEntity student,
  ) {
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
