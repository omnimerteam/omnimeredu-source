import 'package:flutter/material.dart';
import '../../../../widgets/text_field/primary_text_field.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/class/class_search_entity.dart';
import '../../../common/class_selector/class_selector.dart';

class ClassAndDateSelector extends StatefulWidget {
  final String schoolId;
  final EducationGradesEnum? gradeGroup;
  final String? initialClassId;
  final DateTime? initialDate;

  final ValueChanged<ClassSearchEntity?> onClassChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNewOrDelete;
  final VoidCallback? onQRAttendance;
  final String queryString;
  final bool isLoading;
  final bool hasAttendance;

  const ClassAndDateSelector({
    super.key,
    required this.schoolId,
    this.gradeGroup,
    this.initialClassId,
    this.initialDate,
    required this.onClassChanged,
    required this.onDateChanged,
    required this.onRefresh,
    required this.onNewOrDelete,
    this.onQRAttendance,
    this.queryString = "",
    this.isLoading = false,
    this.hasAttendance = false,
  });

  @override
  State<ClassAndDateSelector> createState() => _ClassAndDateSelectorState();
}

class _ClassAndDateSelectorState extends State<ClassAndDateSelector> {
  late TextEditingController _dateController;
  late FocusNode _dateFocusNode;
  DateTime? _selectedDate;
  ClassSearchEntity? _selectedClass;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _dateController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );
    _dateFocusNode = FocusNode();
    _dateFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateChanged(picked);
    }
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
    return widget.hasAttendance ? Colors.redAccent : theme.colorScheme.primary;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: theme.cardTheme.elevation ?? 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Bên trái: Class + Date
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  ClassSelector(
                    schoolId: widget.schoolId,
                    gradeGroup: widget.gradeGroup,
                    initialClassId: widget.initialClassId,
                    queryString: widget.queryString,
                    onClassSelected: (clazz) {
                      setState(() {
                        _selectedClass = clazz;
                      });
                      widget.onClassChanged(clazz);
                    },
                    autoLoad: false,
                  ),
                  const SizedBox(height: 12),
                  PrimaryTextField(
                    controller: _dateController,
                    focusNode: _dateFocusNode,
                    hintText: 'Chọn ngày',
                    prefixIcon: Icons.calendar_today,
                    isFocused: _dateFocusNode.hasFocus,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: _dateController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDate = null;
                                _dateController.clear();
                              });
                              // Thông báo về việc clear date
                              widget.onDateChanged(DateTime.now());
                            },
                          )
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 🔹 Bên phải: Action buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Nút tạo mới / xóa với tooltip
                Tooltip(
                  message: _actionTooltip,
                  child: Material(
                    color: _getActionButtonColor(theme),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: _canPerformAction ? widget.onNewOrDelete : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(_actionIcon, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: widget.hasAttendance && _canPerformAction
                            ? widget.onQRAttendance
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.qr_code_2,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // 🔄 Refresh button
                Tooltip(
                  message: widget.isLoading ? 'Đang tải...' : 'Làm mới dữ liệu',
                  child: Material(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: widget.isLoading ? null : widget.onRefresh,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: widget.isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.secondary,
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                color: theme.colorScheme.secondary,
                                size: 24,
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
}
