import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/tuition_enum.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/grade_select/grade_multi_select.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/student_selector/student_multi_selector.dart';

import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/primary_dropdown.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_multiline_text_field.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/class_selector_multi.dart';

import '../bloc/extra_fee_management_bloc.dart';
import '../bloc/extra_fee_management_event.dart';
import '../bloc/extra_fee_management_state.dart';

class ExtraFeeFormDialog extends StatefulWidget {
  final ExtraFeeEntity? extraFee;
  final String schoolId;

  const ExtraFeeFormDialog({super.key, this.extraFee, required this.schoolId});

  @override
  State<ExtraFeeFormDialog> createState() => _ExtraFeeFormDialogState();
}

class _ExtraFeeFormDialogState extends State<ExtraFeeFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _unitAmountController;
  late TextEditingController _unitNameController;
  late TextEditingController _priorityController;
  late TextEditingController _taxRateController;
  late TextEditingController _formulaController;

  FeeCalcTypeEnum? _selectedCalcType;
  ExtraFeeApplicabilityScopeEnum? _selectedScope;
  ExtraFeeOncePerEnum? _selectedOncePer;

  List<String> _selectedClassIds = [];
  List<String> _selectedGradeIds = [];
  List<String> _selectedStudentIds = [];

  DateTime? _effectiveFrom;
  DateTime? _effectiveTo;
  bool _isTaxable = false;
  bool _isActive = true;
  bool _isSubmitting = false;

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _unitAmountFocusNode = FocusNode();
  final _unitNameFocusNode = FocusNode();
  final _priorityFocusNode = FocusNode();
  final _taxRateFocusNode = FocusNode();
  final _calcTypeFocusNode = FocusNode();
  final _scopeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _unitAmountController = TextEditingController();
    _unitNameController = TextEditingController();
    _priorityController = TextEditingController(text: '0');
    _taxRateController = TextEditingController(text: '0');
  }

  void _loadExistingData() {
    if (widget.extraFee != null) {
      final fee = widget.extraFee!;
      _nameController.text = fee.name;
      _descriptionController.text = fee.description ?? '';
      _unitAmountController.text = fee.unitAmount.toString();
      _unitNameController.text = fee.unitName ?? '';
      _priorityController.text = (fee.priority ?? 0).toString();
      _taxRateController.text = (fee.taxRate ?? 0).toString();

      _selectedCalcType = fee.calcType;
      _selectedScope = fee.applicableScope;
      _selectedOncePer = fee.oncePer ?? ExtraFeeOncePerEnum.none;

      _selectedGradeIds = fee.applicableGradeIds ?? [];
      _selectedStudentIds = fee.applicableStudentIds ?? [];

      _effectiveFrom = fee.effectiveFrom;
      _effectiveTo = fee.effectiveTo;
      _isTaxable = fee.isTaxable ?? false;
      _isActive = fee.active ?? true;
    } else {
      _selectedCalcType = FeeCalcTypeEnum.fixed;
      _selectedScope = ExtraFeeApplicabilityScopeEnum.All;
      _isActive = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitAmountController.dispose();
    _unitNameController.dispose();
    _priorityController.dispose();
    _taxRateController.dispose();

    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _unitAmountFocusNode.dispose();
    _unitNameFocusNode.dispose();
    _priorityFocusNode.dispose();
    _taxRateFocusNode.dispose();
    _calcTypeFocusNode.dispose();
    _scopeFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      // Validate scope-specific selections
      if (_selectedScope == ExtraFeeApplicabilityScopeEnum.Class &&
          _selectedClassIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một lớp')),
        );
        return;
      }
      if (_selectedScope == ExtraFeeApplicabilityScopeEnum.Grade &&
          _selectedGradeIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một khối')),
        );
        return;
      }
      if (_selectedScope == ExtraFeeApplicabilityScopeEnum.Student &&
          _selectedStudentIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất một học sinh')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final extraFee = ExtraFeeEntity(
        id: widget.extraFee?.id,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        calcType: _selectedCalcType!,
        unitAmount: double.parse(_unitAmountController.text),
        unitName: _unitNameController.text.isEmpty
            ? null
            : _unitNameController.text,
        schoolId: widget.extraFee?.schoolId ?? widget.schoolId,
        applicableScope: _selectedScope,
        applicableClassIds:
            _selectedScope == ExtraFeeApplicabilityScopeEnum.Class
            ? _selectedClassIds.toList()
            : null,
        applicableGradeIds:
            _selectedScope == ExtraFeeApplicabilityScopeEnum.Grade
            ? _selectedGradeIds
            : null,
        applicableStudentIds:
            _selectedScope == ExtraFeeApplicabilityScopeEnum.Student
            ? _selectedStudentIds
            : null,
        oncePer: _selectedOncePer,
        priority: int.tryParse(_priorityController.text),
        active: _isActive,
        effectiveFrom: _effectiveFrom,
        effectiveTo: _effectiveTo,
        isTaxable: _isTaxable,
        taxRate: _isTaxable ? double.tryParse(_taxRateController.text) : null,
      );

      final bloc = context.read<ExtraFeeManagementBloc>();
      if (widget.extraFee != null) {
        bloc.add(UpdateExtraFeeEvent(extraFee));
      } else {
        bloc.add(CreateExtraFeeEvent(extraFee));
      }
    }
  }

  void _closeDialog() {
    if (_isSubmitting) return;
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(bool isFrom) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_effectiveFrom ?? DateTime.now())
          : (_effectiveTo ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() {
        if (isFrom) {
          _effectiveFrom = selected;
        } else {
          _effectiveTo = selected;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExtraFeeManagementBloc, ExtraFeeManagementState>(
      listener: (context, state) {
        if (state is ExtraFeeManagementLoaded) {
          if (state.status == ExtraFeeStatus.success && _isSubmitting) {
            Navigator.of(context).pop();
          } else if (state.status == ExtraFeeStatus.error) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Có lỗi xảy ra')),
            );
          }
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 1000),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.extraFee != null
                              ? 'Chỉnh sửa phí phụ'
                              : 'Thêm phí phụ mới',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSubmitting ? null : _closeDialog,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          hintText: 'Tên phí phụ',
                          prefixIcon: Icons.badge,
                          isFocused: _nameFocusNode.hasFocus,
                          required: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tên phí phụ';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Description
                        PrimaryMultilineTextField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          hintText: 'Mô tả chi tiết về phí phụ',
                          prefixIcon: Icons.description,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),

                        // Calc Type
                        Focus(
                          focusNode: _calcTypeFocusNode,
                          child: PrimaryDropdown<FeeCalcTypeEnum>(
                            value: _selectedCalcType,
                            hintText: 'Chọn cách tính phí',
                            prefixIcon: Icons.calculate_outlined,
                            isFocused: _calcTypeFocusNode.hasFocus,
                            items: FeeCalcTypeEnum.values
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type.displayName),
                                  ),
                                )
                                .toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (val) {
                                    setState(() => _selectedCalcType = val);
                                  },
                            validator: (value) {
                              if (value == null) {
                                return 'Vui lòng chọn cách tính phí';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        PrimaryTextField(
                          controller: _unitAmountController,
                          focusNode: _unitAmountFocusNode,
                          hintText: 'Số tiền/đơn vị',
                          prefixIcon: Icons.attach_money,
                          isFocused: _unitAmountFocusNode.hasFocus,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          required: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập số tiền';
                            }
                            if (double.tryParse(value!) == null) {
                              return 'Vui lòng nhập số hợp lệ';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        PrimaryTextField(
                          controller: _unitNameController,
                          focusNode: _unitNameFocusNode,
                          hintText: 'Tên đơn vị (buổi, tháng...)',
                          prefixIcon: Icons.label,
                          isFocused: _unitNameFocusNode.hasFocus,
                        ),

                        const SizedBox(height: 10),

                        PrimaryTextField(
                          controller: _priorityController,
                          focusNode: _priorityFocusNode,
                          hintText: 'Mức ưu tiên',
                          prefixIcon: Icons.priority_high,
                          isFocused: _priorityFocusNode.hasFocus,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 10),

                        // Scope and Applicability
                        Focus(
                          focusNode: _scopeFocusNode,
                          child:
                              PrimaryDropdown<ExtraFeeApplicabilityScopeEnum>(
                                value: _selectedScope,
                                hintText: 'Chọn phạm vi áp dụng',
                                prefixIcon: Icons.public_outlined,
                                isFocused: _scopeFocusNode.hasFocus,
                                items: ExtraFeeApplicabilityScopeEnum.values
                                    .map(
                                      (scope) => DropdownMenuItem(
                                        value: scope,
                                        child: Text(scope.displayName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _isSubmitting
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedScope = val;
                                          _selectedClassIds = [];
                                          _selectedGradeIds = [];
                                          _selectedStudentIds = [];
                                        });
                                      },
                              ),
                        ),
                        const SizedBox(height: 20),

                        // Multi-select based on scope
                        if (_selectedScope ==
                            ExtraFeeApplicabilityScopeEnum.Class) ...[
                          Text(
                            'Chọn lớp học',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          ClassSelectorMulti(
                            schoolId: widget.schoolId,
                            initialClassIds:
                                widget.extraFee?.applicableClassIds,
                            onClassesSelected: (classes) {
                              setState(
                                () => _selectedClassIds = classes
                                    .map((c) => c.id)
                                    .toList(),
                              );
                            },
                            autoLoad: true,
                          ),
                          const SizedBox(height: 20),
                        ],

                        if (_selectedScope ==
                            ExtraFeeApplicabilityScopeEnum.Grade) ...[
                          Text(
                            'Chọn khối',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          GradeMultiSelect(
                            selectedGradeIds: _selectedGradeIds,
                            onChanged: (grades) {
                              setState(
                                () => _selectedGradeIds = grades.toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        if (_selectedScope ==
                            ExtraFeeApplicabilityScopeEnum.Student) ...[
                          Text(
                            'Chọn học sinh',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          StudentMultiSelector(
                            selectedStudentIds: _selectedStudentIds,
                            onChanged: (students) {
                              setState(
                                () => _selectedStudentIds = students.toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Once Per
                        PrimaryDropdown<ExtraFeeOncePerEnum>(
                          value: _selectedOncePer,
                          hintText: 'Chu kỳ áp dụng (tùy chọn)',
                          prefixIcon: Icons.repeat_outlined,
                          items: [null, ...ExtraFeeOncePerEnum.values]
                              .map(
                                (oncePer) => DropdownMenuItem(
                                  value: oncePer,
                                  child: Text(
                                    oncePer == null
                                        ? 'Không'
                                        : oncePer.displayName,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _isSubmitting
                              ? null
                              : (val) {
                                  setState(() => _selectedOncePer = val);
                                },
                        ),
                        const SizedBox(height: 20),

                        // Effective Dates
                        Text(
                          'Ngày hiệu lực',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePickerField(
                                true,
                                'Từ ngày',
                                _effectiveFrom,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDatePickerField(
                                false,
                                'Đến ngày',
                                _effectiveTo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Tax Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tính thuế',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    value: _isTaxable,
                                    onChanged: _isSubmitting
                                        ? null
                                        : (val) =>
                                              setState(() => _isTaxable = val),
                                  ),
                                ],
                              ),
                              if (_isTaxable) ...[
                                const SizedBox(height: 16),
                                PrimaryTextField(
                                  controller: _taxRateController,
                                  focusNode: _taxRateFocusNode,
                                  hintText: 'Tỷ lệ thuế (%)',
                                  prefixIcon: Icons.percent,
                                  isFocused: _taxRateFocusNode.hasFocus,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Active Status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hoạt động',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Switch(
                                value: _isActive,
                                onChanged: _isSubmitting
                                    ? null
                                    : (val) => setState(() => _isActive = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                onPressed: _isSubmitting ? null : _submitForm,
                                text: widget.extraFee != null
                                    ? 'Cập nhật'
                                    : 'Tạo mới',
                                loading: _isSubmitting,
                                type: AppButtonType.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppButton(
                                onPressed: _isSubmitting ? null : _closeDialog,
                                text: 'Hủy',
                                type: AppButtonType.cancel,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePickerField(bool isFrom, String label, DateTime? date) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: _isSubmitting ? null : () => _selectDate(isFrom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null ? date.toString().split(' ')[0] : 'Chọn ngày',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
