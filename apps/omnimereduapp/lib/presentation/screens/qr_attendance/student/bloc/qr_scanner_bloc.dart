import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../domain/usecases/qr_attendance/submit_attendance_usecase.dart';
import '../../../../../domain/usecases/qr_attendance/sync_offline_scans_usecase.dart';
import '../../../../../services/connectivity_service.dart';
import '../../../../../services/location_service.dart' as loc_service;
import '../../../../../core/utils/logger.dart';
import 'qr_scanner_event.dart';
import 'qr_scanner_state.dart';

/// BLoC cho QR Scanner (Student side)
class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final SubmitAttendanceUsecase _submitAttendanceUsecase;
  final SyncOfflineScansUsecase _syncOfflineScansUsecase;
  final ConnectivityService _connectivityService;
  final loc_service.LocationService _locationService;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isOnline = true;
  bool _isProcessing = false;

  QRScannerBloc(
    this._submitAttendanceUsecase,
    this._syncOfflineScansUsecase,
    this._connectivityService,
    this._locationService,
  ) : super(const QRScannerInitial()) {
    on<InitializeScannerEvent>(_onInitializeScanner);
    on<QRCodeScannedEvent>(_onQRCodeScanned);
    on<ResetScannerEvent>(_onResetScanner);
    on<CheckOfflineSyncsEvent>(_onCheckOfflineSyncs);
    on<DisposeScannerEvent>(_onDispose);
  }

  /// Handle initialize scanner event
  Future<void> _onInitializeScanner(
    InitializeScannerEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    try {
      // Check connectivity
      _isOnline = await _connectivityService.hasConnection();

      // Check location permission
      final locationPermission = await _locationService.checkPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        emit(const QRScannerPermissionDenied(
          'Quyền truy cập vị trí bị từ chối vĩnh viễn. '
          'Vui lòng bật quyền trong cài đặt.',
        ));
        return;
      }

      // Get pending offline scans count
      final pendingCount = await _syncOfflineScansUsecase.getPendingCount();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(
        (isOnline) async {
          _isOnline = isOnline;
          if (isOnline) {
            // Auto sync when online
            add(const CheckOfflineSyncsEvent());
          }
          if (state is QRScannerReady) {
            final pending = await _syncOfflineScansUsecase.getPendingCount();
            emit(QRScannerReady(
              isOnline: isOnline,
              pendingOfflineScans: pending,
            ));
          }
        },
      );

      emit(QRScannerReady(
        isOnline: _isOnline,
        pendingOfflineScans: pendingCount,
      ));

      // Auto sync if there are pending scans
      if (pendingCount > 0 && _isOnline) {
        add(const CheckOfflineSyncsEvent());
      }

      AppLogger.info('Scanner initialized. Online: $_isOnline, Pending: $pendingCount');
    } catch (e) {
      AppLogger.error('Failed to initialize scanner', e);
      emit(QRScannerError('Không thể khởi tạo máy quét. Vui lòng thử lại.'));
    }
  }

  /// Handle QR code scanned event
  Future<void> _onQRCodeScanned(
    QRCodeScannedEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    // Prevent multiple scans at once
    if (_isProcessing) {
      AppLogger.warning('Already processing a scan. Ignoring.');
      return;
    }

    try {
      _isProcessing = true;
      emit(const QRScannerScanning());

      AppLogger.info('Processing QR code: ${event.qrData}');

      // Submit attendance
      final result = await _submitAttendanceUsecase(event.qrData);

      emit(QRScannerSuccess(result));

      // Update pending count if offline
      if (!_isOnline) {
        final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
        emit(QRScannerReady(
          isOnline: _isOnline,
          pendingOfflineScans: pendingCount,
        ));
      }

      AppLogger.info('Scan result: ${result.status}');
    } catch (e) {
      AppLogger.error('Failed to process QR code', e);
      
      // Check if it's a location error
      if (e is loc_service.LocationServiceDisabledException) {
        emit(const QRScannerPermissionDenied(
          'Dịch vụ vị trí chưa được bật. Vui lòng bật GPS.',
        ));
      } else if (e is loc_service.LocationPermissionDeniedException) {
        emit(const QRScannerPermissionDenied(
          'Quyền truy cập vị trí bị từ chối. Vui lòng cấp quyền.',
        ));
      } else {
        emit(const QRScannerError(
          'Có lỗi xảy ra khi xử lý mã QR. Vui lòng thử lại.',
        ));
      }
    } finally {
      _isProcessing = false;
    }
  }

  /// Handle reset scanner event
  Future<void> _onResetScanner(
    ResetScannerEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
    emit(QRScannerReady(
      isOnline: _isOnline,
      pendingOfflineScans: pendingCount,
    ));
  }

  /// Handle check offline syncs event
  Future<void> _onCheckOfflineSyncs(
    CheckOfflineSyncsEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    try {
      AppLogger.info('Checking and syncing offline scans...');
      final syncedCount = await _syncOfflineScansUsecase();
      
      if (syncedCount > 0) {
        AppLogger.info('Synced $syncedCount offline scans');
      }

      // Update pending count
      if (state is QRScannerReady) {
        final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
        emit(QRScannerReady(
          isOnline: _isOnline,
          pendingOfflineScans: pendingCount,
        ));
      }
    } catch (e) {
      AppLogger.error('Failed to sync offline scans', e);
    }
  }

  /// Handle dispose event
  Future<void> _onDispose(
    DisposeScannerEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    await _connectivitySubscription?.cancel();
    AppLogger.info('QR Scanner disposed');
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

