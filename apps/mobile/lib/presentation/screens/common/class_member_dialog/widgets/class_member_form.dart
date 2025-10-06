import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/class_selector.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/search_text_field.dart';

class ClassMemberForm extends StatefulWidget {
  final ClassMemberMode mode;
  final String schoolId;
  final String? initialClassId;
  final bool isTeacher;

  const ClassMemberForm({
    super.key,
    required this.mode,
    required this.schoolId,
    this.initialClassId,
    this.isTeacher = false,
  });

  @override
  State<ClassMemberForm> createState() => _ClassMemberFormState();
}

class _ClassMemberFormState extends State<ClassMemberForm> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isFocused = false;
  String? _lastSelectedClassId;
  EducationGradesEnum? selectedGradeGroup;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onSearchChanged() {
    context.read<ClassMemberBloc>().add(
      ChangeSearchQuery(_searchController.text),
    );
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassMemberBloc, ClassMemberState>(
      builder: (context, state) {
        if (state is! ClassMemberLoaded) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFormRow(
                label: "Lớp",
                child: ClassSelector(
                  key: const ValueKey('class_selector_main'),
                  schoolId: widget.schoolId,
                  gradeGroup: selectedGradeGroup,
                  initialClassId: widget.initialClassId,
                  autoLoad: false,
                  onClassSelected: (classEntity) {
                    if (classEntity == null ||
                        classEntity.id == _lastSelectedClassId)
                      return;
                    _lastSelectedClassId = classEntity.id;
                    context.read<ClassMemberBloc>().add(
                      SelectClass(classEntity.id),
                    );
                  },
                ),
              ),

              if (state.mode == ClassMemberMode.transfer &&
                  state.selectedClassId != null) ...[
                const SizedBox(height: 12),
                _buildFormRow(
                  label: "Chuyển tới",
                  child: ClassSelector(
                    key: const ValueKey('target_class_selector'),
                    schoolId: widget.schoolId,
                    gradeGroup: selectedGradeGroup,
                    autoLoad: false,
                    onClassSelected: (classEntity) {
                      if (classEntity != null) {
                        context.read<ClassMemberBloc>().add(
                          SelectTargetClass(classEntity.id),
                        );
                      }
                    },
                  ),
                ),
              ],

              const SizedBox(height: 16),

              if (state.mode == ClassMemberMode.add ||
                  state.selectedClassId != null)
                _buildSearchField(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: SearchTextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        isFocused: _isFocused,
        hintText: "Tìm học sinh",
      ),
    );
  }
}
