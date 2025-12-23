import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/domain/usecases/qr_attendance/submit_attendance_usecase.dart';
import 'package:mobile/domain/usecases/qr_attendance/sync_offline_scans_usecase.dart';
import 'package:mobile/services/qr_service/connectivity_service.dart';
import 'package:mobile/services/qr_service/location_service.dart'
    as loc_service;
import 'package:mobile/core/utils/logger.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/domain/entities/qr_attendance/scan_result_entity.dart';
import 'qr_scanner_event.dart';
import 'qr_scanner_state.dart';

/// BLoC cho QR Scanner (Student side)
class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final SubmitAttendanceUseCase _submitAttendanceUsecase;
  final SyncOfflineScansUseCase _syncOfflineScansUsecase;
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
    AppLogger.info('🚀 QRScannerBloc: InitializeScannerEvent received');
    try {
      // Check connectivity
      AppLogger.debug('🌐 QRScannerBloc: Checking connectivity...');
      _isOnline = await _connectivityService.hasConnection();
      AppLogger.info('🌐 QRScannerBloc: Connectivity check - Online: $_isOnline');

      // Check location permission
      AppLogger.debug('📍 QRScannerBloc: Checking location permission...');
      final locationPermission = await _locationService.checkPermission();
      AppLogger.debug('📍 QRScannerBloc: Location permission - $locationPermission');
      
      if (locationPermission == LocationPermission.deniedForever) {
        AppLogger.warning('⚠️ QRScannerBloc: Location permission denied forever');
        emit(
          const QRScannerPermissionDenied(
            'Quyền truy cập vị trí bị từ chối vĩnh viễn. '
            'Vui lòng bật quyền trong cài đặt.',
          ),
        );
        return;
      }

      // Get pending offline scans count
      AppLogger.debug('📦 QRScannerBloc: Getting pending offline scans count...');
      final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
      AppLogger.info('📦 QRScannerBloc: Pending offline scans: $pendingCount');

      // Listen to connectivity changes
      AppLogger.debug('🔄 QRScannerBloc: Setting up connectivity listener...');
      _connectivitySubscription = _connectivityService.onConnectivityChanged
          .listen((isOnline) {
            AppLogger.info('🔄 QRScannerBloc: Connectivity changed - Online: $isOnline');
            _isOnline = isOnline;
            if (isOnline) {
              // Auto sync when online
              AppLogger.info('🔄 QRScannerBloc: Auto-syncing offline scans...');
              add(const CheckOfflineSyncsEvent());
            }
            // Update state through event instead of direct emit
            // to avoid emit after handler completion
            if (state is QRScannerReady) {
              add(const ResetScannerEvent());
            }
          });
      AppLogger.debug('✅ QRScannerBloc: Connectivity listener set up');

      AppLogger.info('✅ QRScannerBloc: Emitting QRScannerReady state');
      emit(
        QRScannerReady(isOnline: _isOnline, pendingOfflineScans: pendingCount),
      );

      // Auto sync if there are pending scans
      if (pendingCount > 0 && _isOnline) {
        AppLogger.info('🔄 QRScannerBloc: Auto-syncing $pendingCount pending scans...');
        add(const CheckOfflineSyncsEvent());
      }

      AppLogger.info(
        '✅ QRScannerBloc: Scanner initialized successfully. Online: $_isOnline, Pending: $pendingCount',
      );
    } catch (e, stackTrace) {
      AppLogger.error('❌ QRScannerBloc: Failed to initialize scanner', e, stackTrace);
      emit(QRScannerError('Không thể khởi tạo máy quét. Vui lòng thử lại.'));
    }
  }

  /// Handle QR code scanned event
  Future<void> _onQRCodeScanned(
    QRCodeScannedEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    AppLogger.info('📸 QRScannerBloc: QRCodeScannedEvent received');
    
    // Prevent multiple scans at once
    if (_isProcessing) {
      AppLogger.warning('⚠️ QRScannerBloc: Already processing a scan. Ignoring new scan.');
      return;
    }

    try {
      _isProcessing = true;
      AppLogger.info('🔄 QRScannerBloc: Emitting QRScannerScanning state');
      emit(const QRScannerScanning());

      AppLogger.info('📸 QRScannerBloc: Processing QR code: ${event.qrData.substring(0, event.qrData.length > 100 ? 100 : event.qrData.length)}...');

      // Submit attendance
      AppLogger.debug('📤 QRScannerBloc: Submitting attendance...');
      final resultEither = await _submitAttendanceUsecase(event.qrData);

      final scanResult = resultEither.fold(
        (failure) {
          AppLogger.error('❌ QRScannerBloc: Scan failed - ${failure.toString()}');
          emit(QRScannerError(failure.message));
          return null;
        },
        (result) {
          AppLogger.info('✅ QRScannerBloc: Scan result - Status: ${result.status}');
          emit(QRScannerSuccess(result));
          return result;
        },
      );

      // If result is offline, update pending count after showing dialog
      if (scanResult != null && scanResult.status == ScanStatus.offline) {
        AppLogger.info('📦 QRScannerBloc: Scan result is offline, will update pending count');
        // Update state to show pending count after dialog is shown
        // Use add event instead of direct emit to avoid emit after handler completion
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            AppLogger.debug('🔄 QRScannerBloc: Resetting scanner after offline scan');
            add(const ResetScannerEvent());
          }
        });
      }

      // Update pending count if offline
      if (!_isOnline) {
        AppLogger.debug('📦 QRScannerBloc: Updating pending count (offline mode)');
        final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
        emit(
          QRScannerReady(
            isOnline: _isOnline,
            pendingOfflineScans: pendingCount,
          ),
        );
        AppLogger.info('📦 QRScannerBloc: Updated pending count: $pendingCount');
      }
    } catch (e, stackTrace) {
      AppLogger.error('❌ QRScannerBloc: Failed to process QR code', e, stackTrace);

      // Check if it's a location error
      if (e is loc_service.LocationServiceDisabledException) {
        AppLogger.warning('⚠️ QRScannerBloc: Location service disabled');
        emit(
          const QRScannerPermissionDenied(
            'Dịch vụ vị trí chưa được bật. Vui lòng bật GPS.',
          ),
        );
      } else if (e is loc_service.LocationPermissionDeniedException) {
        AppLogger.warning('⚠️ QRScannerBloc: Location permission denied');
        emit(
          const QRScannerPermissionDenied(
            'Quyền truy cập vị trí bị từ chối. Vui lòng cấp quyền.',
          ),
        );
      } else {
        AppLogger.error('❌ QRScannerBloc: Unknown error processing QR code', e, stackTrace);
        emit(
          const QRScannerError(
            'Có lỗi xảy ra khi xử lý mã QR. Vui lòng thử lại.',
          ),
        );
      }
    } finally {
      _isProcessing = false;
      AppLogger.debug('🔄 QRScannerBloc: Processing flag reset');
    }
  }

  /// Handle reset scanner event
  Future<void> _onResetScanner(
    ResetScannerEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    AppLogger.info('🔄 QRScannerBloc: ResetScannerEvent received');
    final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
    AppLogger.info('🔄 QRScannerBloc: Resetting to ready state - Online: $_isOnline, Pending: $pendingCount');
    emit(
      QRScannerReady(isOnline: _isOnline, pendingOfflineScans: pendingCount),
    );
  }

  /// Handle check offline syncs event
  Future<void> _onCheckOfflineSyncs(
    CheckOfflineSyncsEvent event,
    Emitter<QRScannerState> emit,
  ) async {
    try {
      AppLogger.info('Checking and syncing offline scans...');
      final resultEither = await _syncOfflineScansUsecase(NoParams());

      resultEither.fold(
        (failure) {
          AppLogger.error(
            'Failed to sync offline scans: ${failure.toString()}',
          );
        },
        (syncedCount) {
          if (syncedCount > 0) {
            AppLogger.info('Synced $syncedCount offline scans');
          }
        },
      );

      // Update pending count
      if (state is QRScannerReady) {
        final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
        emit(
          QRScannerReady(
            isOnline: _isOnline,
            pendingOfflineScans: pendingCount,
          ),
        );
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
    AppLogger.info('🗑️ QRScannerBloc: DisposeScannerEvent received');
    await _connectivitySubscription?.cancel();
    AppLogger.info('✅ QRScannerBloc: QR Scanner disposed');
  }

  @override
  Future<void> close() {
    AppLogger.info('🗑️ QRScannerBloc: close() called');
    _connectivitySubscription?.cancel();
    AppLogger.info('✅ QRScannerBloc: Connectivity subscription cancelled');
    return super.close();
  }
}
