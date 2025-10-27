import 'package:flutter/material.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import 'school_action_buttons.dart';
import 'school_description_card.dart';
import 'school_header_card.dart';
import 'school_info_grid.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolDataWidget extends StatelessWidget {
  final SchoolDataEntity school;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const SchoolDataWidget({
    Key? key,
    required this.school,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card
        SchoolHeaderCard(school: school),

        const SizedBox(height: 24),

        // Thông tin chi tiết
        Text(
          'Thông tin chi tiết',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(isDark),
          ),
        ),

        const SizedBox(height: 16),

        // Grid thông tin
        SchoolInfoGrid(school: school),

        // Mô tả (nếu có)
        if (school.description != null && school.description!.isNotEmpty) ...[
          const SizedBox(height: 24),
          SchoolDescriptionCard(description: school.description!),
        ],

        const SizedBox(height: 32),

        // Action Buttons
        SchoolActionButtons(
          onEditPressed: onEditPressed,
          onDeletePressed: onDeletePressed,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
