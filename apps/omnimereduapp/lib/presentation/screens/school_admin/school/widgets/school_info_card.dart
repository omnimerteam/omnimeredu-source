import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool isDark;

  const SchoolInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              color: AppColors.getTextColor(isDark).withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 4),

          // Value with flexible text wrapping
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                color: AppColors.getTextColor(isDark),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
