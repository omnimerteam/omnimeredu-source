import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/detail_record/detail_record_student_entity.dart';

/// 🔹 DetailRecordStudentModel - Model tầng data cho chi tiết điểm danh
class DetailRecordStudentModel {
  final String? id;
  final StudentDetailRecordModel? studentId;
  final String? attendanceId;
  final AttendanceStatusEnum? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DetailRecordStudentModel({
    this.id,
    this.studentId,
    this.attendanceId,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Parse từ JSON trả về từ API
  factory DetailRecordStudentModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra kiểu dữ liệu của studentId
    StudentDetailRecordModel? student;
    final studentData = json['studentId'];

    if (studentData is Map<String, dynamic>) {
      // ✅ Trường hợp API populate (trả về object)
      student = StudentDetailRecordModel.fromJson(studentData);
    } else if (studentData is String) {
      // ✅ Trường hợp API chỉ trả về id
      student = StudentDetailRecordModel(
        id: studentData,
        name: '',
        gender: '',
        phone: null,
        guardianName: '',
        guardianPhone: '',
      );
    }

    return DetailRecordStudentModel(
      id: json['_id'] ?? json['id'],
      studentId: student,
      attendanceId: json['attendanceId'],
      status: AttendanceStatusEnum.fromString(json['status']),
      note: json['note'],
      createdAt: (json['createdAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String)!,
            )
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String)!,
            )
          : null,
    );
  }

  /// ✅ Convert sang JSON để gửi lên API (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId?.toJson(),
      'attendanceId': attendanceId,
      'status': status?.name,
      'note': note,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  /// ✅ Convert từ Entity → Model (dùng khi lưu cache / local)
  factory DetailRecordStudentModel.fromEntity(
    DetailRecordStudentEntity entity,
  ) {
    return DetailRecordStudentModel(
      id: entity.id,
      studentId: entity.studentId != null
          ? StudentDetailRecordModel.fromEntity(entity.studentId!)
          : null,
      attendanceId: entity.attendanceId,
      status: entity.status,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// ✅ Convert Model → Entity (dùng khi truyền lên tầng domain)
  DetailRecordStudentEntity toEntity() {
    return DetailRecordStudentEntity(
      id: id,
      studentId: studentId?.toEntity(),
      attendanceId: attendanceId,
      status: status,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 🔹 StudentDetailRecordModel - Model cho thông tin học sinh trong chi tiết điểm danh
class StudentDetailRecordModel {
  final String id;
  final String name;
  final String gender;
  final String? phone;
  final String guardianName;
  final String guardianPhone;

  const StudentDetailRecordModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.guardianName,
    required this.guardianPhone,
  });

  /// ✅ Parse từ JSON trả về từ API
  factory StudentDetailRecordModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailRecordModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'],
      guardianName: json['guardianName'] ?? '',
      guardianPhone: json['guardianPhone'] ?? '',
    );
  }

  /// ✅ Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'gender': gender,
      'phone': phone,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
    };
  }

  /// ✅ Convert từ Entity → Model
  factory StudentDetailRecordModel.fromEntity(
    StudentDetailRecordEntity entity,
  ) {
    return StudentDetailRecordModel(
      id: entity.id,
      name: entity.name,
      gender: entity.gender,
      phone: entity.phone,
      guardianName: entity.guardianName,
      guardianPhone: entity.guardianPhone,
    );
  }

  /// ✅ Convert Model → Entity
  StudentDetailRecordEntity toEntity() {
    return StudentDetailRecordEntity(
      id: id,
      name: name,
      gender: gender,
      phone: phone,
      guardianName: guardianName,
      guardianPhone: guardianPhone,
    );
  }
}
