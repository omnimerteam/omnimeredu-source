import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../domain/entities/attendance/attendance_record_view_entity.dart';

class ClassAndDateSelector extends StatefulWidget {
  final String schoolId;
  final String? initialClassId;
  final DateTime? initialDate;
  final bool isLoading;
  final bool hasAttendance;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNewOrDelete;
  final VoidCallback? onQRAttendance;
  final List<AttendanceClassInfoEntity> classes;

  const ClassAndDateSelector({
    Key? key,
    required this.schoolId,
    this.initialClassId,
    this.initialDate,
    this.isLoading = false,
    this.hasAttendance = false,
    required this.onClassChanged,
    required this.onDateChanged,
    required this.onRefresh,
    required this.onNewOrDelete,
    this.onQRAttendance,
    this.classes = const [],
  }) : super(key: key);

  @override
  State<ClassAndDateSelector> createState() => _ClassAndDateSelectorState();
}

class _ClassAndDateSelectorState extends State<ClassAndDateSelector> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  AttendanceClassInfoEntity? _selectedClass;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _dateController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );
    // Find initial selected class
    if (widget.initialClassId != null && widget.classes.isNotEmpty) {
      _selectedClass = widget.classes
          .cast<AttendanceClassInfoEntity?>()
          .firstWhere(
            (c) => c?.id == widget.initialClassId,
            orElse: () => null,
          );
    }
  }

  @override
  void didUpdateWidget(ClassAndDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected class when classes list changes
    if (widget.classes != oldWidget.classes && widget.initialClassId != null) {
      _selectedClass = widget.classes
          .cast<AttendanceClassInfoEntity?>()
          .firstWhere(
            (c) => c?.id == widget.initialClassId,
            orElse: () => null,
          );
    }
    // Update date if changed externally
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _dateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // ✅ Kiểm tra có thể thực hiện action không
  bool get _canPerformAction {
    return _selectedClass != null && _selectedDate != null && !widget.isLoading;
  }

  // ✅ Xác định màu button dựa trên trạng thái
  Color _getActionButtonColor(ThemeData theme) {
    if (!_canPerformAction) {
      return Colors.grey.withOpacity(0.3);
    }
    return widget.hasAttendance ? AppColors.red : AppColors.success;
  }

  // ✅ Xác định icon button
  IconData get _actionIcon {
    return widget.hasAttendance ? Icons.delete_outline : Icons.add;
  }

  // ✅ Xác định tooltip
  String get _actionTooltip {
    if (!_canPerformAction) {
      if (_selectedClass == null) return 'Vui lòng chọn lớp';
      if (_selectedDate == null) return 'Vui lòng chọn ngày';
      if (widget.isLoading) return 'Đang xử lý...';
    }
    return widget.hasAttendance
        ? 'Xóa bảng điểm danh'
        : 'Tạo bảng điểm danh mới';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: theme.cardTheme.elevation ?? 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Bên trái: Class + Date
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // Class Selector (DropdownSearch)
                  widget.classes.isEmpty
                      ? _buildLoadingState()
                      : DropdownSearch<AttendanceClassInfoEntity>(
                          items: (filter, props) => widget.classes
                              .where(
                                (c) =>
                                    c.name.toLowerCase().contains(
                                      filter.toLowerCase(),
                                    ) ||
                                    c.code.toLowerCase().contains(
                                      filter.toLowerCase(),
                                    ),
                              )
                              .toList(),
                          selectedItem: _selectedClass,
                          itemAsString: (item) => "${item.code} - ${item.name}",
                          compareFn: (a, b) => a.id == b.id,
                          onChanged: (value) {
                            setState(() => _selectedClass = value);
                            widget.onClassChanged(value?.id);
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              hintText: "Chọn lớp",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "Tìm theo tên hoặc mã...",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            menuProps: MenuProps(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                  SizedBox(height: 12.h),
                  // Date Selector
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _dateController.text.isEmpty
                                  ? 'Chọn ngày'
                                  : _dateController.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _dateController.text.isEmpty
                                    ? Colors.grey[600]
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_dateController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = null;
                                  _dateController.clear();
                                });
                                widget.onDateChanged(DateTime.now());
                              },
                              child: Icon(
                                Icons.clear,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // 🔹 Bên phải: Action buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Nút tạo mới / xóa với tooltip
                Tooltip(
                  message: _actionTooltip,
                  child: Material(
                    color: _getActionButtonColor(theme),
                    borderRadius: BorderRadius.circular(8.r),
                    child: InkWell(
                      onTap: _canPerformAction ? widget.onNewOrDelete : null,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(
                          _actionIcon,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // 📱 QR Attendance button
                if (widget.onQRAttendance != null)
                  Tooltip(
                    message: widget.hasAttendance && _canPerformAction
                        ? 'Điểm danh bằng QR'
                        : 'Cần có bảng điểm danh',
                    child: Material(
                      color: widget.hasAttendance && _canPerformAction
                          ? const Color(0xFF6C63FF)
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                      child: InkWell(
                        onTap: widget.hasAttendance && _canPerformAction
                            ? widget.onQRAttendance
                            : null,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          child: Icon(
                            Icons.qr_code_2,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 12.h),

                // 🔄 Refresh button
                Tooltip(
                  message: widget.isLoading ? 'Đang tải...' : 'Làm mới dữ liệu',
                  child: Material(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    child: InkWell(
                      onTap: widget.isLoading ? null : widget.onRefresh,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        child: widget.isLoading
                            ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.secondary,
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                color: theme.colorScheme.secondary,
                                size: 24.sp,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
