import 'package:flutter_ios_android_platforms/domain/entities/view_model/class_detail_view_entity.dart';

class ClassDetailViewModel extends ClassDetailViewEntity {
  const ClassDetailViewModel({
    String? id,
    String? name,
    String? code,
    int? baseFee,
    SchoolClassDetailView? school,
    GradeClassDetailView? grade,
    MainTeacherClassDetailView? mainTeacher,
    List<StudentClassDetailView>? students,
  }) : super(
         id: id,
         name: name,
         code: code,
         baseFee: baseFee,
         school: school,
         grade: grade,
         mainTeacher: mainTeacher,
         students: students,
       );

  factory ClassDetailViewModel.fromJson(Map<String, dynamic> json) {
    return ClassDetailViewModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      baseFee: json['baseFee'] as int?,
      school: json['school'] != null
          ? SchoolClassDetailView(
              id: json['school']['_id'] as String?,
              name: json['school']['name'] as String?,
              code: json['school']['code'] as String?,
              level: json['school']['level'] as String?,
            )
          : null,
      grade: json['grade'] != null
          ? GradeClassDetailView(
              id: json['grade']['_id'] as String?,
              name: json['grade']['name'] as String?,
              level: json['grade']['level'] as String?,
            )
          : null,
      mainTeacher: json['mainTeacher'] != null
          ? MainTeacherClassDetailView(
              id: json['mainTeacher']['_id'] as String?,
              fullName: json['mainTeacher']['fullName'] as String?,
              literacy: json['mainTeacher']['literacy'] as String?,
              qualification: json['mainTeacher']['qualification'] as String?,
            )
          : null,
      students: (json['students'] as List<dynamic>?)
          ?.map(
            (s) => StudentClassDetailView(
              id: s['_id'] as String?,
              fullName: s['fullName'] as String?,
              gender: s['gender'] as String?,
              phone: s['phone'] as String?,
              guardianName: s['guardianName'] as String?,
              guardianPhone: s['guardianPhone'] as String?,
            ),
          )
          .toList(),
    );
  }

  ClassDetailViewEntity toEntity() {
    return ClassDetailViewEntity(
      id: id,
      name: name,
      code: code,
      baseFee: baseFee,
      school: school,
      grade: grade,
      mainTeacher: mainTeacher,
      students: students,
    );
  }
}
