import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_state.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';

class StudentFilterControls extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final Function(Map<String, dynamic>) onFilterChanged;

  const StudentFilterControls({
    super.key,
    this.currentFilter = const {},
    required this.onFilterChanged,
  });

  @override
  State<StudentFilterControls> createState() => _StudentFilterControlsState();
}

class _StudentFilterControlsState extends State<StudentFilterControls> {
  late Map<String, dynamic> _filterData;

  @override
  void initState() {
    super.initState();
    _filterData = Map.from(widget.currentFilter);
  }

  @override
  void didUpdateWidget(covariant StudentFilterControls oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool get _hasActiveFilter => _filterData.isNotEmpty;

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ClassSelectorBloc>()),
            BlocProvider.value(value: context.read<AuthenticationBloc>()),
          ],
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
                    _buildClassSection(context),
                    const SizedBox(height: 20),
                    _buildFilterSection(
                      context,
                      'Giới tính',
                      'gender',
                      DisplayMapper.gender,
                    ),
                    const SizedBox(height: 20),
                    _buildGradeSection(context), // 🔹 thêm filter grade
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
    );
  }

  Widget _buildClassSection(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
      builder: (context, state) {
        if (state is ClassSelectorLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ClassSelectorLoaded) {
          final classes = state.classes;
          final String? selectedClassId = _tempFilterData['classId'] as String?;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lớp học',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: classes.map((clazz) {
                  final isSelected = selectedClassId == clazz.id;
                  return ChoiceChip(
                    label: Text(
                      clazz.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _tempFilterData['classId'] = selected ? clazz.id : null;
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
        return const Text('Không thể tải danh sách lớp');
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

  Widget _buildGradeSection(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is! AuthenticationAuthenticated) {
          return const SizedBox.shrink();
        }
        final AuthUserEntity user = state.user;
        final schoolLevel = user.schoolLevel;
        if (schoolLevel == null) return const SizedBox.shrink();

        final grades = schoolLevel.grades; // 🔹 dùng extension

        if (_tempFilterData['grade'] is! String) {
          _tempFilterData['grade'] = '';
        }
        final selectedGrade = _tempFilterData['grade'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Khối lớp',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: grades.map((grade) {
                final isSelected = selectedGrade == grade.name;
                return ChoiceChip(
                  label: Text(
                    grade.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _tempFilterData['grade'] = selected ? grade.name : '';
                    });
                  },
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
