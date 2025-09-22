import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';

class DashboardCacheService {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Lưu cache
  Future<void> save(String role, DashboardDataBaseEntity data) async {
    try {
      final prefs = await _prefs;

      // Tạo bản copy với cachedAt mới
      final updatedData = data.copyWith(cachedAt: DateTime.now());

      await prefs.setString(role, jsonEncode(updatedData.toJson()));
    } catch (e, s) {
      _logError('save', e, s);
    }
  }

  /// Load cache
  Future<DashboardDataBaseEntity?> load(String role) async {
    try {
      final prefs = await _prefs;
      final cacheString = prefs.getString(role);
      if (cacheString == null) return null;

      final decoded = jsonDecode(cacheString);

      switch (role) {
        case 'schoolAdmin':
          final entity = SchoolAdminDashboardDataEntity.fromJson(decoded);
          return entity.isExpired ? null : entity;
        // TODO: case 'teacher', 'student' ...
        default:
          return null;
      }
    } catch (e, s) {
      _logError('load', e, s);
      return null;
    }
  }

  /// Xóa cache
  Future<void> clear(String role) async {
    try {
      final prefs = await _prefs;
      await prefs.remove(role);
    } catch (e, s) {
      _logError('clear', e, s);
    }
  }

  void _logError(String action, Object error, StackTrace stack) {
    print('[DashboardCacheService][$action] Error: $error\n$stack');
  }
}
