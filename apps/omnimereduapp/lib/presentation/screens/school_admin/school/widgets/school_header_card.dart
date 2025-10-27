import 'package:flutter/material.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolHeaderCard extends StatelessWidget {
  final SchoolDataEntity school;

  const SchoolHeaderCard({Key? key, required this.school}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: school.logoUrl != null && school.logoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      school.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                : const Icon(Icons.school, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 20),

          // Tên trường
          Text(
            school.name ?? 'Chưa có tên',
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "PlayfairDisplay",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Mã trường
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              school.code ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
