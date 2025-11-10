import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

/// 🔹 Entity dùng để Select Grade (chỉ lấy cơ bản)
class GradeSelectEntity extends Equatable {
  final String id;
  final String name;
  final EducationSystemLevelsEnum level;
  final int order;
  final Map<String, int>? ageRange;

  const GradeSelectEntity({
    required this.id,
    required this.name,
    required this.level,
    required this.order,
    this.ageRange,
  });

  @override
  List<Object?> get props => [id, name, level, order, ageRange];

  GradeSelectEntity copyWith({
    String? id,
    String? name,
    EducationSystemLevelsEnum? level,
    int? order,
    Map<String, int>? ageRange,
  }) {
    return GradeSelectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      order: order ?? this.order,
      ageRange: ageRange ?? this.ageRange,
    );
  }
}
