abstract class DashboardDataBaseEntity {
  final DateTime cachedAt;

  const DashboardDataBaseEntity({required this.cachedAt});

  bool get isExpired {
    const maxCacheAge = Duration(minutes: 10);
    return DateTime.now().difference(cachedAt) > maxCacheAge;
  }

  Map<String, dynamic> toJson();

  /// Để abstract, bắt buộc class con phải implement
  DashboardDataBaseEntity copyWith({DateTime? cachedAt});
}
