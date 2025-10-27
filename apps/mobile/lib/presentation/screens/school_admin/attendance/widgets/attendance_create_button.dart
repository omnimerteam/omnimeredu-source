import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/class_selector.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';

/// Nút tạo bảng điểm danh + dialog chọn ngày và lớp.
class AttendanceCreateButton extends StatelessWidget {
  const AttendanceCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        String? schoolId;

        if (authState is AuthenticationAuthenticated) {
          schoolId = authState.user.schoolId;
        }

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
            onPressed: schoolId == null
                ? null
                : () => _showCreateAttendanceDialog(context, schoolId!),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Tạo điểm danh',
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
      },
    );
  }

  /// Hiển thị dialog chọn ngày + lớp học.
  void _showCreateAttendanceDialog(BuildContext context, String schoolId) {
    DateTime selectedDate = DateTime.now();
    ClassSearchEntity? selectedClass;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Tạo bảng điểm danh"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Chọn ngày
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ngày điểm danh:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                          ),
                          label: Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 🔹 Chọn lớp
                BlocProvider.value(
                  value: context.read<ClassSelectorBloc>(),
                  child: ClassSelector(
                    schoolId: schoolId,
                    onClassSelected: (clazz) {
                      selectedClass = clazz;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    text: "Hủy",
                    type: AppButtonType.cancel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    type: AppButtonType.primary,
                    text: "Khởi tạo",
                    onPressed: () {
                      if (selectedClass == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Vui lòng chọn lớp học"),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      Navigator.of(dialogContext).pop();

                      // 🔹 Gửi event khởi tạo điểm danh
                      context.read<AttendanceManagementBloc>().add(
                        InitializeAttendanceEvent(
                          classId: selectedClass!.id,
                          schoolId: schoolId,
                          date: selectedDate,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Đang khởi tạo bảng điểm danh..."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
