abstract class DashboardDataBaseEntity {
  final DateTime cachedAt;

  const DashboardDataBaseEntity({required this.cachedAt});

  bool get isExpired {
    const maxCacheAge = Duration(minutes: 10);
    return DateTime.now().difference(cachedAt) > maxCacheAge;
  }

  /// Tạo bản copy với cachedAt mới
  DashboardDataBaseEntity copyWith({required DateTime cachedAt});

  /// Convert ra Map để lưu cache
  Map<String, dynamic> toJson();
}
