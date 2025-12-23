import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/logger.dart';
import 'bloc/qr_scanner_bloc.dart';
import 'bloc/qr_scanner_event.dart';
import 'bloc/qr_scanner_state.dart';
import 'widgets/scanner_overlay.dart';
import 'widgets/offline_indicator.dart';
import 'widgets/scan_result_dialog.dart';

/// Screen quét QR Code cho sinh viên
class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLogger.info('📱 ScanQrScreen: Building screen widget');
    return BlocProvider(
      create: (context) {
        AppLogger.info(
          '📱 ScanQrScreen: Creating QRScannerBloc and initializing scanner',
        );
        final bloc = GetIt.I<QRScannerBloc>();
        // Delay lâu hơn để đảm bảo camera cũ đã được release hoàn toàn
        // Đặc biệt quan trọng sau hot restart hoặc khi navigate nhanh
        Future.delayed(const Duration(milliseconds: 800), () {
          if (bloc.isClosed) {
            AppLogger.warning(
              '⚠️ ScanQrScreen: Bloc already closed, skipping initialization',
            );
            return;
          }
          AppLogger.info(
            '📱 ScanQrScreen: Sending InitializeScannerEvent after delay',
          );
          bloc.add(const InitializeScannerEvent());
        });
        return bloc;
      },
      child: const _ScanQrScreenContent(),
    );
  }
}

class _ScanQrScreenContent extends StatefulWidget {
  const _ScanQrScreenContent({Key? key}) : super(key: key);

  @override
  State<_ScanQrScreenContent> createState() => _ScanQrScreenContentState();
}

class _ScanQrScreenContentState extends State<_ScanQrScreenContent> {
  MobileScannerController? _scannerController;
  QRScannerBloc? _bloc;
  bool _isTorchOn = false;
  bool _isScannerReady = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  DateTime? _controllerCreationTime;
  static const Duration _cameraTimeout = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    AppLogger.info('📱 ScanQrScreen: initState called');
    // Không khởi tạo controller ở đây, đợi đến khi BLoC emit QRScannerReady
    // để tránh race condition với việc dispose camera cũ
  }

  void _initializeScanner() {
    try {
      // Đảm bảo dispose controller cũ trước khi tạo mới
      if (_scannerController != null) {
        AppLogger.warning(
          '⚠️ ScanQrScreen: Controller already exists, disposing old one...',
        );
        try {
          _scannerController?.dispose();
          _scannerController = null;
          // Đợi một chút để camera được release hoàn toàn
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _createNewController();
            }
          });
          return;
        } catch (e, stackTrace) {
          AppLogger.error(
            '❌ ScanQrScreen: Error disposing old controller',
            e,
            stackTrace,
          );
        }
      }
      _createNewController();
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ ScanQrScreen: Failed to initialize scanner',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  void _createNewController() {
    try {
      AppLogger.info(
        '📷 ScanQrScreen: Creating new MobileScannerController... (attempt ${_retryCount + 1}/$_maxRetries)',
      );
      AppLogger.debug(
        '📷 ScanQrScreen: Controller params - detectionSpeed: noDuplicates, facing: back, torchEnabled: false',
      );

      _controllerCreationTime = DateTime.now();
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );
      AppLogger.info(
        '✅ ScanQrScreen: MobileScannerController created successfully',
      );
      AppLogger.debug(
        '📷 ScanQrScreen: Controller hash: ${_scannerController.hashCode}',
      );

      // Reset retry count khi thành công
      _retryCount = 0;
      _controllerCreationTime = null;

      // Trigger rebuild để hiển thị scanner view
      if (mounted) {
        AppLogger.debug(
          '📷 ScanQrScreen: Triggering rebuild after controller creation',
        );
        setState(() {
          // Controller đã được tạo, widget sẽ rebuild
        });
      }

      // Monitor camera timeout - nếu camera không mở được sau 10s, hiển thị lỗi
      Future.delayed(_cameraTimeout, () {
        if (mounted &&
            _scannerController != null &&
            _controllerCreationTime != null) {
          final elapsed = DateTime.now().difference(_controllerCreationTime!);
          if (elapsed >= _cameraTimeout) {
            AppLogger.error(
              '❌ ScanQrScreen: Camera timeout - Camera may be locked by another process or emulator issue',
            );
            // Dispose controller và hiển thị error
            _scannerController?.dispose();
            _scannerController = null;
            if (mounted) {
              _bloc?.add(const InitializeScannerEvent());
            }
          }
        }
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ ScanQrScreen: Failed to create MobileScannerController',
        e,
        stackTrace,
      );
      _retryCount++;

      // Retry với exponential backoff nếu chưa vượt quá max retries
      if (mounted && _retryCount < _maxRetries) {
        final retryDelay = Duration(seconds: _retryCount * 2);
        AppLogger.warning(
          '⚠️ ScanQrScreen: Retrying initialization in ${retryDelay.inSeconds}s (attempt $_retryCount/$_maxRetries)...',
        );
        Future.delayed(retryDelay, () {
          if (mounted && _scannerController == null) {
            _createNewController();
          }
        });
      } else if (_retryCount >= _maxRetries) {
        AppLogger.error(
          '❌ ScanQrScreen: Max retries ($_maxRetries) reached. Camera may be locked by another process.',
        );
        // Emit error state để hiển thị lỗi cho user
        if (mounted) {
          _bloc?.add(const InitializeScannerEvent());
        }
      }
    }
  }

  @override
  void dispose() {
    AppLogger.info('🗑️ ScanQrScreen: dispose called');
    AppLogger.debug(
      '📷 ScanQrScreen: Controller state before dispose - isNull: ${_scannerController == null}',
    );

    // Dispose controller trước - đảm bảo camera được release
    if (_scannerController != null) {
      try {
        AppLogger.debug('📷 ScanQrScreen: Stopping controller...');
        _scannerController?.stop();
        AppLogger.debug(
          '📷 ScanQrScreen: Disposing MobileScannerController...',
        );
        final controllerHash = _scannerController?.hashCode;
        _scannerController?.dispose();
        _scannerController = null;
        AppLogger.info(
          '✅ ScanQrScreen: MobileScannerController (hash: $controllerHash) disposed and set to null',
        );
      } catch (e, stackTrace) {
        AppLogger.error(
          '❌ ScanQrScreen: Error stopping/disposing MobileScannerController',
          e,
          stackTrace,
        );
        _scannerController = null; // Force set to null even if dispose fails
        AppLogger.warning(
          '⚠️ ScanQrScreen: Forced controller to null after dispose error',
        );
      }
    } else {
      AppLogger.debug(
        '📷 ScanQrScreen: Controller is already null, nothing to dispose',
      );
    }

    // Reset retry count
    _retryCount = 0;

    // Dispose bloc
    if (_bloc != null) {
      AppLogger.debug(
        '🗑️ ScanQrScreen: Sending DisposeScannerEvent to bloc...',
      );
      _bloc?.add(const DisposeScannerEvent());
    }

    super.dispose();
    AppLogger.info('✅ ScanQrScreen: dispose completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'Quét mã điểm danh',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        actions: [
          // Only show torch button when scanner is ready
          if (_isScannerReady)
            IconButton(
              icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
              onPressed: () {
                // Only toggle torch if controller is initialized
                if (_scannerController != null) {
                  try {
                    AppLogger.debug(
                      '💡 ScanQrScreen: Toggling torch - Current: $_isTorchOn',
                    );
                    _scannerController!.toggleTorch();
                    setState(() {
                      _isTorchOn = !_isTorchOn;
                    });
                    AppLogger.debug(
                      '💡 ScanQrScreen: Torch toggled - New: $_isTorchOn',
                    );
                  } catch (e, stackTrace) {
                    // Controller not initialized yet, ignore
                    AppLogger.error(
                      '❌ ScanQrScreen: Cannot toggle torch',
                      e,
                      stackTrace,
                    );
                  }
                } else {
                  AppLogger.warning(
                    '⚠️ ScanQrScreen: Cannot toggle torch - controller is null',
                  );
                }
              },
            ),
        ],
      ),
      body: BlocConsumer<QRScannerBloc, QRScannerState>(
        listener: (context, state) {
          // Store bloc reference for dispose
          _bloc ??= context.read<QRScannerBloc>();

          AppLogger.debug(
            '🔄 ScanQrScreen: State changed to ${state.runtimeType}',
          );

          if (state is QRScannerSuccess) {
            AppLogger.info(
              '✅ ScanQrScreen: QR scan successful - ${state.result.status}',
            );
            _showResultDialog(context, state);
          } else if (state is QRScannerError) {
            AppLogger.warning(
              '⚠️ ScanQrScreen: QR scan error - ${state.message}',
            );
            _showErrorSnackbar(context, state.message);
            // Reset to ready state after showing error
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.read<QRScannerBloc>().add(const ResetScannerEvent());
              }
            });
          } else if (state is QRScannerPermissionDenied) {
            AppLogger.warning(
              '⚠️ ScanQrScreen: Permission denied - ${state.message}',
            );
            _showPermissionDialog(context, state.message);
          } else if (state is QRScannerReady) {
            AppLogger.info(
              '✅ ScanQrScreen: Scanner ready - Online: ${state.isOnline}, Pending: ${state.pendingOfflineScans}',
            );
            // Ensure scanner controller is initialized when ready
            if (_scannerController == null) {
              AppLogger.info(
                '📷 ScanQrScreen: Controller is null when ready, initializing...',
              );
              // Đợi lâu hơn để đảm bảo camera cũ đã được release hoàn toàn
              // Đặc biệt quan trọng sau hot restart
              final delay = _retryCount == 0
                  ? const Duration(milliseconds: 1500)
                  : Duration(milliseconds: 1500 + (_retryCount * 500));

              AppLogger.info(
                '📷 ScanQrScreen: Will create controller after ${delay.inMilliseconds}ms delay (retry: $_retryCount)',
              );
              Future.delayed(delay, () {
                if (mounted && _scannerController == null) {
                  AppLogger.info(
                    '📷 ScanQrScreen: Creating controller after delay...',
                  );
                  _initializeScanner();
                } else if (!mounted) {
                  AppLogger.warning(
                    '⚠️ ScanQrScreen: Widget not mounted, skipping controller creation',
                  );
                } else {
                  AppLogger.debug(
                    '📷 ScanQrScreen: Controller already created, skipping',
                  );
                }
              });
            } else {
              AppLogger.debug('📷 ScanQrScreen: Controller already exists');
              // Reset retry count nếu controller đã tồn tại
              _retryCount = 0;
            }
            // Mark scanner as ready
            if (!_isScannerReady) {
              AppLogger.info('📷 ScanQrScreen: Marking scanner as ready');
              setState(() {
                _isScannerReady = true;
              });
            }
          } else if (state is QRScannerInitial) {
            AppLogger.info('🔄 ScanQrScreen: Scanner initializing...');
          } else if (state is QRScannerScanning) {
            AppLogger.info('🔍 ScanQrScreen: Processing QR code...');
          } else {
            // Scanner not ready in other states
            if (_isScannerReady) {
              AppLogger.debug('📷 ScanQrScreen: Marking scanner as not ready');
              setState(() {
                _isScannerReady = false;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is QRScannerInitial) {
            return _buildLoadingView();
          } else if (state is QRScannerPermissionDenied) {
            return _buildPermissionDeniedView(context, state.message);
          } else if (state is QRScannerScanning) {
            return _buildScanningView();
          } else if (state is QRScannerError) {
            return _buildErrorView(context, state.message);
          } else if (state is QRScannerReady) {
            return _buildScannerView(context, state);
          }

          // Fallback to loading view
          return _buildLoadingView();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Đang khởi tạo máy quét...',
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text('Đang xử lý...', style: TextStyle(color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _buildScannerView(BuildContext context, QRScannerReady state) {
    // Only show scanner if controller is initialized
    if (_scannerController == null) {
      AppLogger.warning(
        '⚠️ ScanQrScreen: _buildScannerView called but controller is null',
      );
      return _buildLoadingView();
    }

    AppLogger.info('📷 ScanQrScreen: Building scanner view with controller');
    return Stack(
      children: [
        // Camera Scanner
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? qrData = barcodes.first.rawValue;
              if (qrData != null && qrData.isNotEmpty) {
                final preview = qrData.length > 50
                    ? '${qrData.substring(0, 50)}...'
                    : qrData;
                AppLogger.info('📸 ScanQrScreen: QR code detected - $preview');
                context.read<QRScannerBloc>().add(QRCodeScannedEvent(qrData));
              } else {
                AppLogger.debug(
                  '📸 ScanQrScreen: QR code detected but data is null or empty',
                );
              }
            }
          },
          errorBuilder: (context, error, child) {
            AppLogger.error(
              '❌ ScanQrScreen: MobileScanner error - ${error.toString()}',
              error,
            );

            // Kiểm tra nếu là lỗi camera bị lock
            final errorString = error.toString().toLowerCase();
            final isCameraLocked =
                errorString.contains('max_cameras_in_use') ||
                errorString.contains('camera') && errorString.contains('use');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCameraLocked
                          ? 'Camera đang được sử dụng'
                          : 'Lỗi camera',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isCameraLocked
                          ? 'Camera đang bị khóa bởi ứng dụng khác hoặc emulator. Vui lòng:\n\n1. Đóng các ứng dụng đang sử dụng camera\n2. Restart emulator/device\n3. Thử lại'
                          : 'Lỗi: ${error.toString()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        AppLogger.info(
                          '🔄 ScanQrScreen: Retrying camera initialization...',
                        );
                        _scannerController?.dispose();
                        _scannerController = null;
                        _isScannerReady = false;
                        _retryCount = 0;
                        _controllerCreationTime = null;
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            _initializeScanner();
                          }
                        });
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Overlay
        const ScannerOverlayWidget(),
        // Offline indicator at bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: OfflineIndicatorWidget(
            isOnline: state.isOnline,
            pendingScans: state.pendingOfflineScans,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              'Lỗi',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<QRScannerBloc>().add(const ResetScannerEvent());
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              'Yêu cầu quyền truy cập',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, QRScannerSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ScanResultDialog(
        result: state.result,
        onClose: () {
          Navigator.pop(dialogContext);
          // Reset scanner to ready state
          context.read<QRScannerBloc>().add(const ResetScannerEvent());
        },
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Yêu cầu quyền truy cập'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
