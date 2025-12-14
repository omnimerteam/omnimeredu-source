import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/qr_attendance/offline_scan_model.dart';
import '../core/utils/logger.dart';

/// Service để quản lý hàng đợi offline scans
class OfflineQueueService {
  static Database? _database;
  static const String tableName = 'offline_scans';

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'qr_attendance.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            qrData TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            deviceId TEXT NOT NULL,
            scanTime TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0,
            errorMessage TEXT
          )
        ''');
        AppLogger.info('Offline queue database created');
      },
    );
  }

  /// Add scan to offline queue
  Future<int> addScan(OfflineScanModel scan) async {
    try {
      final db = await database;
      final id = await db.insert(tableName, scan.toDatabase());
      AppLogger.info('Offline scan added with ID: $id');
      return id;
    } catch (e) {
      AppLogger.error('Failed to add offline scan', e);
      rethrow;
    }
  }

  /// Get all unsynced scans
  Future<List<OfflineScanModel>> getUnsyncedScans() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: 'isSynced = ?',
        whereArgs: [0],
        orderBy: 'scanTime ASC',
      );

      return maps.map((map) => OfflineScanModel.fromDatabase(map)).toList();
    } catch (e) {
      AppLogger.error('Failed to get unsynced scans', e);
      return [];
    }
  }

  /// Get count of unsynced scans
  Future<int> getUnsyncedCount() async {
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName WHERE isSynced = 0'),
      );
      return count ?? 0;
    } catch (e) {
      AppLogger.error('Failed to get unsynced count', e);
      return 0;
    }
  }

  /// Mark scan as synced
  Future<void> markAsSynced(int id) async {
    try {
      final db = await database;
      await db.update(
        tableName,
        {'isSynced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
      AppLogger.info('Scan $id marked as synced');
    } catch (e) {
      AppLogger.error('Failed to mark scan as synced', e);
    }
  }

  /// Update scan error message
  Future<void> updateError(int id, String errorMessage) async {
    try {
      final db = await database;
      await db.update(
        tableName,
        {'errorMessage': errorMessage},
        where: 'id = ?',
        whereArgs: [id],
      );
      AppLogger.info('Error message updated for scan $id');
    } catch (e) {
      AppLogger.error('Failed to update error message', e);
    }
  }

  /// Delete synced scans older than specified days
  Future<void> cleanupOldScans({int daysOld = 7}) async {
    try {
      final db = await database;
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      await db.delete(
        tableName,
        where: 'isSynced = ? AND scanTime < ?',
        whereArgs: [1, cutoffDate.toIso8601String()],
      );
      AppLogger.info('Cleaned up scans older than $daysOld days');
    } catch (e) {
      AppLogger.error('Failed to cleanup old scans', e);
    }
  }

  /// Delete specific scan
  Future<void> deleteScan(int id) async {
    try {
      final db = await database;
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      AppLogger.info('Scan $id deleted');
    } catch (e) {
      AppLogger.error('Failed to delete scan', e);
    }
  }

  /// Delete all scans (for testing/reset)
  Future<void> deleteAllScans() async {
    try {
      final db = await database;
      await db.delete(tableName);
      AppLogger.info('All scans deleted');
    } catch (e) {
      AppLogger.error('Failed to delete all scans', e);
    }
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      AppLogger.info('Database closed');
    }
  }
}

