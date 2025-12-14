import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/qr_attendance/generate_qr_code_usecase.dart';
import '../../../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../../../../services/brightness_service.dart';
import '../../../../../core/utils/logger.dart';
import 'qr_display_event.dart';
import 'qr_display_state.dart';

/// BLoC cho QR Display (Teacher side)
class QRDisplayBloc extends Bloc<QRDisplayEvent, QRDisplayState> {
  final GenerateQRCodeUsecase _generateQRCodeUsecase;
  final BrightnessService _brightnessService;
  
  Timer? _countdownTimer;
  QRCodeEntity? _currentQRCode;

  QRDisplayBloc(
    this._generateQRCodeUsecase,
    this._brightnessService,
  ) : super(const QRDisplayInitial()) {
    on<GenerateQRCodeEvent>(_onGenerateQRCode);
    on<RefreshQRCodeEvent>(_onRefreshQRCode);
    on<QRCodeExpiredEvent>(_onQRCodeExpired);
    on<DisposeQRDisplayEvent>(_onDispose);
    on<UpdateQRCountdownEvent>(_onUpdateCountdown);
  }

  /// Handle generate QR code event
  Future<void> _onGenerateQRCode(
    GenerateQRCodeEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    try {
      emit(const QRDisplayLoading());

      // Set max brightness
      await _brightnessService.setMaxBrightness();

      // Generate QR code
      final qrCode = await _generateQRCodeUsecase(event.attendanceId);
      _currentQRCode = qrCode;

      // Emit success state
      emit(QRDisplaySuccess(
        qrCode: qrCode,
        remainingSeconds: qrCode.remainingSeconds,
      ));

      // Start countdown timer
      _startCountdownTimer();

      AppLogger.info('QR code generated: ${event.attendanceId}');
    } catch (e) {
      // Extract user-friendly error message
      String errorMessage = 'Không thể tạo mã QR. Vui lòng thử lại.';
      final errorStr = e.toString();
      
      if (errorStr.contains('404') || errorStr.contains('Không tìm thấy')) {
        errorMessage = 'Không tìm thấy thông tin điểm danh. Vui lòng kiểm tra lại.';
      } else if (errorStr.contains('timeout') || errorStr.contains('thời gian')) {
        errorMessage = 'Kết nối quá thời gian. Vui lòng kiểm tra kết nối mạng và thử lại.';
      } else if (errorStr.contains('connection') || errorStr.contains('internet')) {
        errorMessage = 'Không có kết nối internet. Vui lòng kiểm tra và thử lại.';
      }
      
      // Không log lại vì đã log chi tiết ở ApiClient interceptor
      // Chỉ emit error state để UI hiển thị
      emit(QRDisplayError(errorMessage));
      
      // Restore brightness on error
      await _brightnessService.restoreOriginalBrightness();
    }
  }

  /// Handle refresh QR code event
  Future<void> _onRefreshQRCode(
    RefreshQRCodeEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    // Cancel existing timer
    _cancelCountdownTimer();
    
    // Generate new QR code
    await _onGenerateQRCode(
      GenerateQRCodeEvent(event.attendanceId),
      emit,
    );
  }

  /// Handle QR code expired event
  Future<void> _onQRCodeExpired(
    QRCodeExpiredEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    if (_currentQRCode != null) {
      emit(QRDisplayExpired(_currentQRCode!));
      _cancelCountdownTimer();
      AppLogger.info('QR code expired');
    }
  }

  /// Handle dispose event
  Future<void> _onDispose(
    DisposeQRDisplayEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    _cancelCountdownTimer();
    await _brightnessService.restoreOriginalBrightness();
    AppLogger.info('QR Display disposed');
  }

  /// Handle update countdown event
  void _onUpdateCountdown(
    UpdateQRCountdownEvent event,
    Emitter<QRDisplayState> emit,
  ) {
    if (_currentQRCode != null && state is QRDisplaySuccess) {
      emit(QRDisplaySuccess(
        qrCode: _currentQRCode!,
        remainingSeconds: event.remainingSeconds,
      ));
    }
  }

  /// Start countdown timer
  void _startCountdownTimer() {
    _cancelCountdownTimer();

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_currentQRCode == null) {
          timer.cancel();
          return;
        }

        final remainingSeconds = _currentQRCode!.remainingSeconds;

        if (remainingSeconds <= 0) {
          add(const QRCodeExpiredEvent());
        } else if (state is QRDisplaySuccess) {
          // Update remaining seconds by adding an event
          add(UpdateQRCountdownEvent(remainingSeconds: remainingSeconds));
        }
      },
    );
  }

  /// Cancel countdown timer
  void _cancelCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  Future<void> close() {
    _cancelCountdownTimer();
    _brightnessService.restoreOriginalBrightness();
    return super.close();
  }
}

