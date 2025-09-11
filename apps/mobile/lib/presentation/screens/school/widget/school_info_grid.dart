import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school/widget/school_info_card.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';

class SchoolInfoGrid extends StatelessWidget {
  final SchoolDataEntity school;

  const SchoolInfoGrid({Key? key, required this.school}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2, // Adjusted for better text display
      children: [
        SchoolInfoCard(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          value: school.address ?? 'Chưa cập nhật',
          color: AppColors.info,
          isDark: isDark,
        ),
        SchoolInfoCard(
          icon: Icons.phone,
          title: 'Điện thoại',
          value: school.phone ?? 'Chưa cập nhật',
          color: AppColors.success,
          isDark: isDark,
        ),
        SchoolInfoCard(
          icon: Icons.school,
          title: 'Cấp học',
          value:
              DisplayMapper.educationLevelName(school.level) ?? 'Chưa xác định',
          color: AppColors.warning,
          isDark: isDark,
        ),
        SchoolInfoCard(
          icon: Icons.people,
          title: 'Học sinh',
          value: '${school.studentCount ?? 0}',
          color: Colors.purple,
          isDark: isDark,
        ),
      ],
    );
  }
}
