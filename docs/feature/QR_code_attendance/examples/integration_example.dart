// Example: Integrating QR Attendance into your app
// File: examples/qr_attendance_integration_example.dart

import 'package:flutter/material.dart';

/// EXAMPLE 1: Teacher - Creating QR Code for Attendance
/// 
/// Use case: Giáo viên muốn tạo mã QR cho buổi học
class TeacherAttendanceExample extends StatelessWidget {
  const TeacherAttendanceExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách lớp học')),
      body: ListView(
        children: [
          // Example: Class card with QR button
          ClassCard(
            className: '10A1',
            subject: 'Toán',
            onCreateQR: () {
              _showQRCode(
                context,
                attendanceId: 'attendance_abc123',
                className: '10A1',
                subject: 'Toán',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showQRCode(
    BuildContext context, {
    required String attendanceId,
    required String className,
    String? subject,
  }) {
    // Import the QR display screen
    // import 'package:omnimereduapp/presentation/screens/qr_attendance/teacher/qr_display_screen.dart';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDisplayScreen(
          attendanceId: attendanceId,
          className: className,
          subject: subject,
          date: DateTime.now(),
        ),
      ),
    );
  }
}

/// EXAMPLE 2: Student - Scanning QR Code
/// 
/// Use case: Sinh viên muốn quét mã QR để điểm danh
class StudentAttendanceExample extends StatelessWidget {
  const StudentAttendanceExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điểm danh')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 100),
            const SizedBox(height: 24),
            const Text(
              'Quét mã QR để điểm danh',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _openScanner(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Mở máy quét'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openScanner(BuildContext context) {
    // Import the QR scanner screen
    // import 'package:omnimereduapp/presentation/screens/qr_attendance/student/qr_scanner_screen.dart';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );
  }
}

/// EXAMPLE 3: Custom Integration - From Attendance List
/// 
/// Use case: Tích hợp từ màn hình danh sách điểm danh
class AttendanceListExample extends StatelessWidget {
  const AttendanceListExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách điểm danh')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return AttendanceItem(
            date: DateTime.now().subtract(Duration(days: index)),
            className: '10A1',
            status: index == 0 ? 'Đang diễn ra' : 'Đã kết thúc',
            onShowQR: () {
              // Show QR for this attendance
              _showQRCode(context, 'attendance_$index');
            },
          );
        },
      ),
    );
  }

  void _showQRCode(BuildContext context, String attendanceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDisplayScreen(
          attendanceId: attendanceId,
          className: '10A1',
          subject: 'Toán',
          date: DateTime.now(),
        ),
      ),
    );
  }
}

/// EXAMPLE 4: Initialize Auto Sync Service in main.dart
/// 
/// Add this to your main.dart file
/*
import 'package:get_it/get_it.dart';
import 'services/auto_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await init();
  
  // Start auto sync service for offline attendance
  final autoSyncService = GetIt.instance<AutoSyncService>();
  autoSyncService.start();
  
  runApp(MyApp());
}
*/

/// EXAMPLE 5: Handle Scan Result Programmatically
/// 
/// Use case: Xử lý kết quả quét trong code
class ManualScanHandlingExample {
  // Import necessary files
  // import 'domain/usecases/qr_attendance/submit_attendance_usecase.dart';
  // import 'domain/entities/qr_attendance/scan_result_entity.dart';
  
  Future<void> handleQRScan(String qrData) async {
    /*
    final submitUsecase = GetIt.instance<SubmitAttendanceUsecase>();
    
    try {
      final result = await submitUsecase(qrData);
      
      switch (result.status) {
        case ScanStatus.success:
          print('✅ Điểm danh thành công!');
          break;
        case ScanStatus.offline:
          print('📱 Đã lưu offline');
          break;
        case ScanStatus.outOfRange:
          print('❌ Ngoài phạm vi: ${result.distance}m');
          break;
        case ScanStatus.expired:
          print('⏰ Mã QR đã hết hạn');
          break;
        default:
          print('❌ Lỗi: ${result.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
    */
  }
}

/// EXAMPLE 6: Check Offline Queue Status
/// 
/// Use case: Kiểm tra số lượng điểm danh chưa sync
class OfflineQueueExample {
  // Import
  // import 'services/offline_queue_service.dart';
  
  Future<void> checkPendingScans() async {
    /*
    final offlineService = GetIt.instance<OfflineQueueService>();
    final pendingCount = await offlineService.getUnsyncedCount();
    
    print('Pending offline scans: $pendingCount');
    
    if (pendingCount > 0) {
      // Trigger manual sync
      final autoSyncService = GetIt.instance<AutoSyncService>();
      final synced = await autoSyncService.triggerSync();
      print('Synced $synced scans');
    }
    */
  }
}

/// EXAMPLE 7: Custom QR Display with Additional Info
/// 
/// Use case: Hiển thị QR với thông tin bổ sung
class CustomQRDisplayExample extends StatelessWidget {
  final String attendanceId;
  final Map<String, dynamic> additionalInfo;

  const CustomQRDisplayExample({
    Key? key,
    required this.attendanceId,
    required this.additionalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRDisplayScreen(
      attendanceId: attendanceId,
      className: additionalInfo['className'] as String,
      subject: additionalInfo['subject'] as String?,
      date: additionalInfo['date'] as DateTime,
    );
  }
}

/// EXAMPLE 8: Listen to Connectivity Changes
/// 
/// Use case: Theo dõi trạng thái mạng
class ConnectivityListenerExample extends StatefulWidget {
  const ConnectivityListenerExample({Key? key}) : super(key: key);

  @override
  State<ConnectivityListenerExample> createState() =>
      _ConnectivityListenerExampleState();
}

class _ConnectivityListenerExampleState
    extends State<ConnectivityListenerExample> {
  // Import
  // import 'services/connectivity_service.dart';
  
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    /*
    final connectivityService = GetIt.instance<ConnectivityService>();
    
    connectivityService.onConnectivityChanged.listen((isOnline) {
      setState(() {
        _isOnline = isOnline;
      });
      
      if (isOnline) {
        // Trigger sync when back online
        print('Back online! Syncing...');
      }
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        actions: [
          // Connection indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _isOnline ? Icons.wifi : Icons.wifi_off,
              color: _isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          _isOnline ? 'Online' : 'Offline',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// =================================================================
// Helper Widgets (for examples above)
// =================================================================

class ClassCard extends StatelessWidget {
  final String className;
  final String subject;
  final VoidCallback onCreateQR;

  const ClassCard({
    Key? key,
    required this.className,
    required this.subject,
    required this.onCreateQR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: const Icon(Icons.class_),
        title: Text('Lớp $className'),
        subtitle: Text(subject),
        trailing: ElevatedButton.icon(
          onPressed: onCreateQR,
          icon: const Icon(Icons.qr_code),
          label: const Text('Tạo QR'),
        ),
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final DateTime date;
  final String className;
  final String status;
  final VoidCallback onShowQR;

  const AttendanceItem({
    Key? key,
    required this.date,
    required this.className,
    required this.status,
    required this.onShowQR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('Điểm danh ${date.day}/${date.month}/${date.year}'),
        subtitle: Text('$className - $status'),
        trailing: status == 'Đang diễn ra'
            ? IconButton(
                icon: const Icon(Icons.qr_code_2),
                onPressed: onShowQR,
              )
            : null,
      ),
    );
  }
}

// Placeholder imports (uncomment when using)
// These are just for syntax, actual imports will be different
class QRDisplayScreen extends StatelessWidget {
  final String attendanceId;
  final String className;
  final String? subject;
  final DateTime date;

  const QRDisplayScreen({
    Key? key,
    required this.attendanceId,
    required this.className,
    this.subject,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Placeholder();
}

