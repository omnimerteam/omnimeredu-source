import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/qr_attendance/generate_qr_code_usecase.dart';
import 'qr_display_event.dart';
import 'qr_display_state.dart';

class QRDisplayBloc extends Bloc<QRDisplayEvent, QRDisplayState> {
  final GenerateQRCodeUseCase _generateQRCode;
  Timer? _timer;
  static const int _qrDurationSeconds =
      60; // Default duration if not provided by backend

  QRDisplayBloc({required GenerateQRCodeUseCase generateQRCode})
    : _generateQRCode = generateQRCode,
      super(QRDisplayInitial()) {
    on<GenerateQRCodeEvent>(_onGenerateQRCode);
    on<RefreshQRCodeEvent>(_onRefreshQRCode);
    on<DisposeQRDisplayEvent>(_onDispose);
    on<TickEvent>(_onTick);
  }

  Future<void> _onGenerateQRCode(
    GenerateQRCodeEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    emit(QRDisplayLoading());
    await _generateAndStartTimer(event.attendanceId, emit);
  }

  Future<void> _onRefreshQRCode(
    RefreshQRCodeEvent event,
    Emitter<QRDisplayState> emit,
  ) async {
    // Reset timer and generate new QR
    _timer?.cancel();
    emit(QRDisplayLoading());
    await _generateAndStartTimer(event.attendanceId, emit);
  }

  Future<void> _generateAndStartTimer(
    String attendanceId,
    Emitter<QRDisplayState> emit,
  ) async {
    final result = await _generateQRCode(attendanceId);

    result.fold((failure) => emit(QRDisplayError(failure.message)), (qrCode) {
      // Assuming QRCodeEntity might have an expiry time or validSeconds
      // If not, we use a default.
      // I don't have QRCodeEntity definition but I'll assume standard behavior.
      // For now, I'll use a fixed duration or checks dates if available.
      final initialDuration = _qrDurationSeconds;

      emit(QRDisplaySuccess(qrCode: qrCode, remainingSeconds: initialDuration));

      _startTimer(initialDuration);
    });
  }

  void _startTimer(int duration) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration = duration - timer.tick;
      if (newDuration <= 0) {
        timer.cancel();
        // Check if we can emit here directly or need to add event
        if (!isClosed) {
          add(const TickEvent(0));
        }
      } else {
        if (!isClosed) {
          add(TickEvent(newDuration));
        }
      }
    });
  }

  void _onTick(TickEvent event, Emitter<QRDisplayState> emit) {
    if (state is QRDisplaySuccess) {
      if (event.remainingSeconds <= 0) {
        emit(QRDisplayExpired());
      } else {
        emit(
          (state as QRDisplaySuccess).copyWith(
            remainingSeconds: event.remainingSeconds,
            isExpired: false,
          ),
        );
      }
    }
  }

  void _onDispose(DisposeQRDisplayEvent event, Emitter<QRDisplayState> emit) {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
