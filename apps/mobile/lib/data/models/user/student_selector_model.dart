import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_selector_entity.dart';

class StudentSelectorModel {
  final String id;
  final String fullName;
  final String gender;
  final bool isVerified;
  final String? classId;
  final String? className;
  final EducationGradesEnum gradeGroup;

  const StudentSelectorModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.isVerified,
    this.classId,
    this.className,
    required this.gradeGroup,
  });

  /// Chuyển từ JSON của backend thành model
  factory StudentSelectorModel.fromJson(Map<String, dynamic> json) {
    final classData = json['classId'] as Map<String, dynamic>?;

    return StudentSelectorModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      classId: classData?['_id'] as String?,
      className: classData?['name'] as String?,
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String?),
    );
  }

  /// Chuyển sang entity để sử dụng trong domain layer
  StudentSelectorEntity toEntity() {
    return StudentSelectorEntity(
      id: id,
      fullName: fullName,
      gender: gender,
      isVerified: isVerified,
      classId: classId,
      className: className,
      gradeGroup: gradeGroup,
    );
  }

  /// Nếu cần convert ngược lại JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'isVerified': isVerified,
      'classId': classId,
      'className': className,
      'gradeGroup': gradeGroup.name,
    };
  }
}
