import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? schoolId;
  final String? gradeId; // 🔹 chỉ giữ id của grade
  final int? maxStudents;
  final int? baseFee;
  final List<String>? students; // 🔹 danh sách id học sinh

  const ClassEntity({
    this.id,
    this.name,
    this.code,
    this.schoolId,
    this.gradeId,
    this.maxStudents,
    this.baseFee,
    this.students,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    schoolId,
    gradeId,
    maxStudents,
    baseFee,
    students,
  ];

  /// 🔹 Parse từ JSON (backend/cache → entity)
  factory ClassEntity.fromJson(Map<String, dynamic> json) {
    return ClassEntity(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      schoolId: json['schoolId'] as String?,
      gradeId: json['gradeId'] is Map
          ? (json['gradeId'] as Map<String, dynamic>)['_id'] as String?
          : json['gradeId'] as String?,
      maxStudents: json['maxStudents'] as int?,
      baseFee: json['baseFee'] as int?,
      students: (json['students'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  /// 🔹 Convert sang JSON (entity → cache/backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'gradeId': gradeId,
      'maxStudents': maxStudents,
      'baseFee': baseFee,
      'students': students,
    };
  }
}
