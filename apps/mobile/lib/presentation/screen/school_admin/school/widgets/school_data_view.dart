import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import 'school_action_buttons.dart';
import 'school_description_card.dart';
import 'school_header_card.dart';
import 'school_info_grid.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolDataView extends StatelessWidget {
  final SchoolDataEntity school;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const SchoolDataView({
    super.key,
    required this.school,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card
        SchoolHeaderCard(school: school),

        SizedBox(height: 24.h),

        // Thông tin chi tiết
        Text(
          'Thông tin chi tiết',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(isDark),
          ),
        ),

        SizedBox(height: 16.h),

        // Grid thông tin
        SchoolInfoGrid(school: school),

        // Mô tả (nếu có)
        if (school.description != null && school.description!.isNotEmpty) ...[
          SizedBox(height: 24.h),
          SchoolDescriptionCard(description: school.description!),
        ],

        SizedBox(height: 32.h),

        // Action Buttons
        SchoolActionButtons(
          onEditPressed: onEditPressed,
          onDeletePressed: onDeletePressed,
        ),

        SizedBox(height: 32.h),
      ],
    );
  }
}
