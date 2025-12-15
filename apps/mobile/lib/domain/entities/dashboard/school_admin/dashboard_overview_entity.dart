class DashboardOverviewEntity {
  final int totalStudents;
  final int totalTeachers;
  final int totalClasses;
  final int totalStaff;
  final int membershipRequests;
  final DateTime lastUpdated;

  const DashboardOverviewEntity({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalClasses,
    required this.totalStaff,
    required this.membershipRequests,
    required this.lastUpdated,
  });

  /// Convert Entity -> Map
  Map<String, dynamic> toJson() => {
    'totalStudents': totalStudents,
    'totalTeachers': totalTeachers,
    'totalClasses': totalClasses,
    'totalStaff': totalStaff,
    'membershipRequests': membershipRequests,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  /// Convert Map -> Entity
  factory DashboardOverviewEntity.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewEntity(
      totalStudents: json['totalStudents'] ?? 0,
      totalTeachers: json['totalTeachers'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      totalStaff: json['totalStaff'] ?? 0,
      membershipRequests: json['membershipRequests'] ?? 0,
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
