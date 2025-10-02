import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/class_selector.dart';

class ClassAndDateSelector extends StatefulWidget {
  final String schoolId;
  final EducationGradesEnum? gradeGroup;
  final String? initialClassId;
  final DateTime? initialDate;

  final ValueChanged<ClassSearchEntity?> onClassChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNewOrUpdate;
  final String queryString;
  final bool isLoading; // 🔹 Thêm trạng thái loading
  final bool canCreate; // 🔹 Cho phép tạo hay không

  const ClassAndDateSelector({
    super.key,
    required this.schoolId,
    this.gradeGroup,
    this.initialClassId,
    this.initialDate,
    required this.onClassChanged,
    required this.onDateChanged,
    required this.onRefresh,
    required this.onNewOrUpdate,
    this.queryString = "",
    this.isLoading = false, // 🔹 Mặc định false
    this.canCreate = true, // 🔹 Mặc định true
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Top: Class selector + New button
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ClassSelector(
                    schoolId: widget.schoolId,
                    gradeGroup: widget.gradeGroup,
                    initialClassId: widget.initialClassId,
                    queryString: widget.queryString,
                    onClassSelected: widget.onClassChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: AppButton(
                    onPressed: widget.canCreate && !widget.isLoading
                        ? widget.onNewOrUpdate
                        : null, // 🔹 Disable nếu đang loading hoặc không cho phép
                    text: widget.isLoading ? "Đang tạo..." : "Tạo mới",
                    type: AppButtonType.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Bottom: Date picker + Refresh
            Row(
              children: [
                Expanded(
                  child: PrimaryTextField(
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
                ),
                const SizedBox(width: 12),
                Material(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: widget.isLoading
                        ? null
                        : widget.onRefresh, // 🔹 Disable khi loading
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
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
