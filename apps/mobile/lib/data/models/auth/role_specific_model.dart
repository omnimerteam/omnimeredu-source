// Ví dụ các model riêng biệt cho từng role
Map<String, dynamic> RoleSchoolAdminModel(Map<String, dynamic> json) => {
  'position': json['position'] ?? '',
};

Map<String, dynamic> RoleStudentModel(Map<String, dynamic> json) => {
  'educationLevel': json['educationLevel'],
  'guardianName': json['guardianName'],
  'guardianPhone': json['guardianPhone'],
  'classId': json['classId'],
  'grade': json['grade'],
};

Map<String, dynamic> RoleTeacherModel(Map<String, dynamic> json) => {
  'literacy': json['literacy'],
  'subjects': json['subjects'] ?? [],
};

Map<String, dynamic> RoleSuperAdminModel(Map<String, dynamic> json) => {};
