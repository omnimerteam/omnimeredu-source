import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/view_model/class_detail_view_entity.dart';

/// 🔹 Model chính: ClassDetailViewModel
class ClassDetailViewModel {
  final String id;
  final String name;
  final String code;
  final int? baseFee;
  final SchoolClassDetailEntity? school;
  final GradeClassDetailEntity? grade;
  final List<TeacherClassDetailEntity>? teachers;
  final List<StudentClassDetailEntity>? students;

  const ClassDetailViewModel({
    required this.id,
    required this.name,
    required this.code,
    this.baseFee,
    this.school,
    this.grade,
    this.teachers,
    this.students,
  });

  /// Parse từ JSON
  factory ClassDetailViewModel.fromJson(Map<String, dynamic> json) {
    return ClassDetailViewModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      baseFee: json['baseFee'] as int?,
      school: json['school'] != null
          ? SchoolClassDetailEntity(
              id: json['school']['_id'] as String,
              name: json['school']['name'] as String,
              code: json['school']['code'] as String,
              level: EducationSystemLevelsEnum.fromString(
                json['school']['level'] as String?,
              ),
            )
          : null,
      grade: json['grade'] != null
          ? GradeClassDetailEntity(
              id: json['grade']['_id'] as String,
              name: json['grade']['name'] as String,
              level: EducationSystemLevelsEnum.fromString(
                json['grade']['level'] as String?,
              ),
              gradeGroup: EducationGradesEnum.fromString(
                json['grade']['gradeGroup'] as String?,
              ),
            )
          : null,
      teachers: (json['teachers'] as List<dynamic>?)
          ?.map(
            (t) => TeacherClassDetailEntity(
              id: t['_id'] as String,
              fullName: t['fullName'] as String,
              subject: SubjectEnum.fromString(t['subject'] as String?),
              qualification: TeacherQualificationEnum.fromString(
                t['qualification'] as String?,
              ),
              isMain: t['isMain'] as bool? ?? false,
            ),
          )
          .toList(),
      students: (json['students'] as List<dynamic>?)
          ?.map(
            (s) => StudentClassDetailEntity(
              id: s['_id'] as String,
              fullName: s['fullName'] as String,
              gender: s['gender'] as String?,
              phone: s['phone'] as String?,
              address: s['address'] as String?,
              guardianName: s['guardianName'] as String?,
              guardianPhone: s['guardianPhone'] as String?,
            ),
          )
          .toList(),
    );
  }

  /// Convert Model -> Entity
  ClassDetailViewEntity toEntity() {
    return ClassDetailViewEntity(
      id: id,
      name: name,
      code: code,
      baseFee: baseFee,
      school: school,
      grade: grade,
      teachers: teachers,
      students: students,
    );
  }
}
