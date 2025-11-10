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
  final String queryString;
  final bool isLoading;
  final bool canCreate;

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
    this.queryString = "",
    this.isLoading = false,
    this.canCreate = true,
    this.hasAttendance = false,
  });

  @override
  State<ClassAndDateSelector> createState() => _ClassAndDateSelectorState();
}

class _ClassAndDateSelectorState extends State<ClassAndDateSelector> {
  late TextEditingController _dateController;
  late FocusNode _dateFocusNode;
  DateTime? _selectedDate;

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
                    onClassSelected: widget.onClassChanged,
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
                // ✅ Nút tạo mới / xóa tự đổi icon
                Material(
                  color: widget.hasAttendance
                      ? Colors.redAccent.withOpacity(
                          widget.canCreate && !widget.isLoading ? 1 : 0.4,
                        )
                      : theme.colorScheme.primary.withOpacity(
                          widget.canCreate && !widget.isLoading ? 1 : 0.4,
                        ),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: widget.canCreate && !widget.isLoading
                        ? widget.onNewOrDelete
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        widget.hasAttendance ? Icons.delete_outline : Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔄 Refresh
                Material(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: widget.isLoading ? null : widget.onRefresh,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.secondary,
                              ),
                            )
                          : Icon(
                              Icons.refresh,
                              color: theme.colorScheme.secondary,
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
