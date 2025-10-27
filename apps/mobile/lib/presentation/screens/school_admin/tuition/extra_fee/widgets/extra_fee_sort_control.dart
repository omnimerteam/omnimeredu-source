import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/sort/multi_sort_bottom_sheet.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/search_text_field.dart';
import '../bloc/extra_fee_management_bloc.dart';
import '../bloc/extra_fee_management_event.dart';
import '../bloc/extra_fee_management_state.dart';

class ExtraFeeSortControls extends StatefulWidget {
  const ExtraFeeSortControls({super.key});

  @override
  State<ExtraFeeSortControls> createState() => _ExtraFeeSortControlsState();
}

class _ExtraFeeSortControlsState extends State<ExtraFeeSortControls> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    context.read<ExtraFeeManagementBloc>().add(SearchExtraFeeEvent(value));
  }

  // Các tùy chọn sắp xếp cho phí phụ
  static const Map<Map<String, String>, String> _extraFeeSortOptions = {
    {'code': 'asc'}: 'Mã phí A-Z',
    {'code': 'desc'}: 'Mã phí Z-A',
    {'name': 'asc'}: 'Tên phí A-Z',
    {'name': 'desc'}: 'Tên phí Z-A',
    {'taxRate': 'desc'}: 'Thuế giảm dần',
    {'taxRate': 'asc'}: 'Thuế tăng dần',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ExtraFeeManagementBloc, ExtraFeeManagementState>(
      builder: (context, state) {
        if (state is! ExtraFeeManagementLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bộ lọc & Sắp xếp',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: 'Tìm kiếm theo tên phí phụ...',
                isFocused: _searchFocusNode.hasFocus,
                onFieldSubmitted: _onSearchSubmitted,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchSubmitted('');
                        },
                      )
                    : null,
              ),

              const SizedBox(height: 16),

              // Sort
              MultiSortBottomSheet(
                currentSort: state.currentQuery.sort,
                sortOptions: _extraFeeSortOptions,
                onApply: (selected) {
                  context.read<ExtraFeeManagementBloc>().add(
                    SortExtraFeeEvent(selected),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
