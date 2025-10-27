import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolDescriptionCard extends StatelessWidget {
  final String description;

  const SchoolDescriptionCard({Key? key, required this.description})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mô tả',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextColor(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Inter",
              height: 1.5,
              color: AppColors.getTextColor(isDark).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
