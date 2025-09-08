class DashboardOverviewEntity {
  final int totalStudents;
  final int totalTeachers;
  final int totalClasses;
  final int membershipRequests;
  final DateTime lastUpdated;

  const DashboardOverviewEntity({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalClasses,
    required this.membershipRequests,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'totalStudents': totalStudents,
    'totalTeachers': totalTeachers,
    'totalClasses': totalClasses,
    'membershipRequests': membershipRequests,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory DashboardOverviewEntity.fromJson(Map<String, dynamic> json) =>
      DashboardOverviewEntity(
        totalStudents: json['totalStudents'] ?? 0,
        totalTeachers: json['totalTeachers'] ?? 0,
        totalClasses: json['totalClasses'] ?? 0,
        membershipRequests: json['membershipRequests'] ?? 0,
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );
}
