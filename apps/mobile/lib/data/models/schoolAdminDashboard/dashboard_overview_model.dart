import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';

class DashboardOverviewModel extends DashboardOverviewEntity {
  const DashboardOverviewModel({
    required super.totalStudents,
    required super.totalTeachers,
    required super.totalClasses,
    required super.totalStaff,
    required super.membershipRequests,
    required super.lastUpdated,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewModel(
      totalStudents: json['totalStudents'] ?? 0,
      totalTeachers: json['totalTeachers'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      totalStaff: json['totalStaff'] ?? 0,
      membershipRequests: json['membershipRequests'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalStudents': totalStudents,
    'totalTeachers': totalTeachers,
    'totalClasses': totalClasses,
    'totalStaff': totalStaff,
    'membershipRequests': membershipRequests,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  DashboardOverviewEntity toEntity() {
    return DashboardOverviewEntity(
      totalStudents: totalStudents,
      totalTeachers: totalTeachers,
      totalClasses: totalClasses,
      totalStaff: totalStaff,
      membershipRequests: membershipRequests,
      lastUpdated: lastUpdated,
    );
  }
}
