import 'package:flutter_ios_android_platforms/domain/entities/auth/user_entity.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.classId,
    super.guardianName,
    super.guardianPhone,
    required super.educationLevel,
    super.grade,
    super.registeredExtraFees,
    super.registeredDiscounts,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleId: json['roleId'] ?? '',
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      phone: json['phone'],
      address: json['address'],
      isVerified: json['isVerified'] ?? false,
      schoolId: json['schoolId'],
      avatarUrl: json['avatarUrl'],
      classId: json['classId'],
      guardianName: json['guardianName'],
      guardianPhone: json['guardianPhone'],
      educationLevel: json['educationLevel'] ?? '',
      grade: json['grade'],
      registeredExtraFees: json['registeredExtraFees'] != null
          ? (json['registeredExtraFees'] as List)
                .map((e) => RegisteredExtraFeeModel.fromJson(e))
                .toList()
          : null,
      registeredDiscounts: json['registeredDiscounts'] != null
          ? List<String>.from(json['registeredDiscounts'])
          : null,
    );
  }
}

class TeacherModel extends Teacher {
  const TeacherModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.literacy,
    super.subjects,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleId: json['roleId'] ?? '',
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      phone: json['phone'],
      address: json['address'],
      isVerified: json['isVerified'] ?? false,
      schoolId: json['schoolId'],
      avatarUrl: json['avatarUrl'],
      literacy: json['literacy'],
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : null,
    );
  }
}

class SchoolAdminModel extends SchoolAdmin {
  const SchoolAdminModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.position = "Hiệu trưởng",
  });

  factory SchoolAdminModel.fromJson(Map<String, dynamic> json) {
    return SchoolAdminModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleId: json['roleId'] ?? '',
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      phone: json['phone'],
      address: json['address'],
      isVerified: json['isVerified'] ?? false,
      schoolId: json['schoolId'],
      avatarUrl: json['avatarUrl'],
      position: json['position'] ?? "Hiệu trưởng",
    );
  }
}

class SuperAdminModel extends SuperAdmin {
  const SuperAdminModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
  });

  factory SuperAdminModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleId: json['roleId'] ?? '',
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      phone: json['phone'],
      address: json['address'],
      isVerified: json['isVerified'] ?? false,
      schoolId: json['schoolId'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class RegisteredExtraFeeModel extends RegisteredExtraFee {
  const RegisteredExtraFeeModel({
    required super.extraFeeId,
    required super.amount,
  });

  factory RegisteredExtraFeeModel.fromJson(Map<String, dynamic> json) {
    return RegisteredExtraFeeModel(
      extraFeeId: json['extraFeeId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'extraFeeId': extraFeeId, 'amount': amount};
  }
}
