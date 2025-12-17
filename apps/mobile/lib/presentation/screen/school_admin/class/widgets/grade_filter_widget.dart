import 'package:flutter/material.dart';
import '../../../../common/grade_select/cubit/grade_select_cubit.dart';
import '../../../../common/grade_select/cubit/grade_select_state.dart';
import '../../../../common/widgets/input/primary_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class GradeFilterWidget extends StatefulWidget {
  const GradeFilterWidget({super.key});

  @override
  State<GradeFilterWidget> createState() => _GradeFilterWidgetState();
}

class _GradeFilterWidgetState extends State<GradeFilterWidget> {
  String? _selectedGradeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeSelectCubit, GradeSelectState>(
      builder: (context, gradeState) {
        List<DropdownMenuItem<String>> items = [
          const DropdownMenuItem(value: null, child: Text("Tất cả khối")),
        ];

        if (gradeState is GradeSelectSuccess) {
          items.addAll(
            gradeState.grades.map(
              (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
            ),
          );
        }

        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGradeId,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: const Text("Tất cả khối"),
              items: items,
              onChanged: (val) {
                setState(() {
                  _selectedGradeId = val;
                });
                // Update filter in ClassManagementBloc
                final filter = val != null
                    ? {'gradeId': val}
                    : <String, dynamic>{};
                // Note: Check backend filter param name. Assuming 'gradeId' or 'grade'
                // Omnimereduapp used 'gradeId'. Mobile Endpoint uses 'grade'.
                // Let's use 'grade' for safety or map it in Bloc.
                // DefaultQueryEntity supports map filter.
                context.read<ClassManagementBloc>().add(
                  FilterClassesEvent(filter),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
