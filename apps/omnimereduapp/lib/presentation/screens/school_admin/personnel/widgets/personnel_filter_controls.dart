import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../auth/role/bloc/role_bloc.dart';
import '../../../../utils/display_mapper.dart';
import '../../../../widgets/button/app_button.dart';

class PersonnelFilterControls extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final Function(Map<String, dynamic>) onFilterChanged;

  const PersonnelFilterControls({
    super.key,
    this.currentFilter = const {},
    required this.onFilterChanged,
  });

  @override
  State<PersonnelFilterControls> createState() =>
      _PersonnelFilterControlsState();
}

class _PersonnelFilterControlsState extends State<PersonnelFilterControls> {
  late Map<String, dynamic> _filterData;

  @override
  void initState() {
    super.initState();
    _filterData = Map.from(widget.currentFilter);
  }

  @override
  void didUpdateWidget(covariant PersonnelFilterControls oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool get _hasActiveFilter => _filterData.isNotEmpty;

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return MultiBlocProvider(
          providers: [BlocProvider.value(value: context.read<RoleBloc>())],
          child: _FilterBottomSheetContent(
            currentFilter: _filterData,
            onApply: (newFilter) {
              setState(() => _filterData = Map.from(newFilter));
              widget.onFilterChanged(_filterData);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lọc theo',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        OutlinedButton.icon(
          onPressed: _showFilterBottomSheet,
          icon: Icon(
            Icons.filter_list_alt,
            color: _hasActiveFilter ? theme.colorScheme.primary : null,
          ),
          label: Text(
            _hasActiveFilter ? 'Đã lọc (${_filterData.length})' : 'Chọn bộ lọc',
            style: TextStyle(
              fontWeight: _hasActiveFilter ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBottomSheetContent extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final ValueChanged<Map<String, dynamic>> onApply;

  const _FilterBottomSheetContent({
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  late Map<String, dynamic> _tempFilterData;

  static const Map<String, String> personnelNames = {
    'SchoolAdmin': 'Quản trị trường',
    'Teacher': 'Giáo viên',
    'Security': 'Bảo vệ',
    'Nurse': 'Y tá',
    'CanteenStaff': 'Nhân viên căng tin',
  };

  // Mapping for position filter
  static final Map<String, String> _positionOptions = Map.fromEntries(
    SchoolAdminPositionEnum.values.map((e) => MapEntry(e.name, e.displayName)),
  );

  // Mapping for qualification filter
  static final Map<String, String> _qualificationOptions = Map.fromEntries(
    TeacherQualificationEnum.values.map((e) => MapEntry(e.name, e.displayName)),
  );

  // Mapping for subjects filter
  static final Map<String, String> _subjectOptions = Map.fromEntries(
    SubjectEnum.values.map((e) => MapEntry(e.name, e.displayName)),
  );

  @override
  void initState() {
    super.initState();
    _tempFilterData = Map<String, dynamic>.from(widget.currentFilter);
  }

  void _clearFilter() {
    setState(() {
      _tempFilterData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Chọn bộ lọc',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection(
                        context,
                        'Giới tính',
                        'gender',
                        DisplayMapper.gender,
                      ),
                      const SizedBox(height: 20),
                      _buildRoleSection(context),
                      const SizedBox(height: 20),
                      _buildFilterSection(
                        context,
                        'Chức vụ (Quản trị trường)',
                        'position',
                        _positionOptions,
                      ),
                      const SizedBox(height: 20),
                      _buildFilterSection(
                        context,
                        'Trình độ (Giáo viên)',
                        'qualification',
                        _qualificationOptions,
                      ),
                      const SizedBox(height: 20),
                      _buildFilterSection(
                        context,
                        'Môn học (Giáo viên)',
                        'subjects',
                        _subjectOptions,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  AppButton(
                    onPressed: _clearFilter,
                    text: 'Xóa',
                    type: AppButtonType.danger,
                    fullWidth: false,
                    width: 120,
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Hủy',
                    type: AppButtonType.cancel,
                    fullWidth: false,
                    width: 80,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        widget.onApply(_tempFilterData);
                        Navigator.pop(context);
                      },
                      text: 'Áp dụng',
                      type: AppButtonType.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSection(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        if (state is RoleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RolePersonnelLoaded) {
          final String? selectedRoleId = _tempFilterData['roleId'] as String?;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vai trò',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: state.roles.map((role) {
                  final isSelected = selectedRoleId == role.id;
                  final displayName = personnelNames[role.name] ?? role.name;
                  return ChoiceChip(
                    label: Text(
                      displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _tempFilterData['roleId'] = selected ? role.id : null;
                      });
                    },
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const Text('Không thể tải danh sách vai trò');
      },
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    String filterKey,
    Map<String, String> options,
  ) {
    final theme = Theme.of(context);

    if (_tempFilterData[filterKey] is! String) {
      _tempFilterData[filterKey] = '';
    }
    final selectedValue = _tempFilterData[filterKey];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.entries.map((entry) {
            final isSelected = selectedValue == entry.key;
            return ChoiceChip(
              label: Text(
                entry.value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _tempFilterData[filterKey] = selected ? entry.key : '';
                });
              },
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
            );
          }).toList(),
        ),
      ],
    );
  }
}
