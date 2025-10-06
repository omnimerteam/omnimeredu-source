import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class StudentSelectorEntity extends Equatable {
  final String id;
  final String fullName;
  final String gender;
  final bool isVerified;
  final String? classId;
  final String? className;
  final EducationGradesEnum gradeGroup;

  const StudentSelectorEntity({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.isVerified,
    this.classId,
    this.className,
    required this.gradeGroup,
  });

  /// Tạo bản copy với một số field thay đổi
  StudentSelectorEntity copyWith({
    String? id,
    String? fullName,
    String? gender,
    bool? isVerified,
    String? classId,
    String? className,
    EducationGradesEnum? gradeGroup,
  }) {
    return StudentSelectorEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      isVerified: isVerified ?? this.isVerified,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      gradeGroup: gradeGroup ?? this.gradeGroup,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    gender,
    isVerified,
    classId,
    className,
    gradeGroup,
  ];
}
