import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import 'bloc/qr_scanner_bloc.dart';
import 'bloc/qr_scanner_event.dart';
import 'bloc/qr_scanner_state.dart';
import 'widgets/scanner_overlay.dart';
import 'widgets/offline_indicator.dart';
import 'widgets/scan_result_dialog.dart';

/// Screen quét QR Code cho sinh viên
class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<QRScannerBloc>()..add(const InitializeScannerEvent()),
      child: const _QRScannerScreenContent(),
    );
  }
}

class _QRScannerScreenContent extends StatefulWidget {
  const _QRScannerScreenContent({Key? key}) : super(key: key);

  @override
  State<_QRScannerScreenContent> createState() =>
      _QRScannerScreenContentState();
}

class _QRScannerScreenContentState extends State<_QRScannerScreenContent> {
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    // Check if context is valid before reading bloc in dispose if needed,
    // though usually bloc provider handles closure or we use proper cleanup.
    // context.read<QRScannerBloc>().add(const DisposeScannerEvent());
    // Note: DisposeScannerEvent might not be needed if BlocProvider handles closing,
    // but the original code had it. I'll check if context is mounted or just skip it
    // as GetIt might be managing the singleton or factory.
    // If it's a factory, BlocProvider closes it.
    // If we want to reset state:
    // context.read<QRScannerBloc>().add(const ResetScannerEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<QRScannerBloc, QRScannerState>(
        listener: (context, state) {
          if (state is QRScannerSuccess) {
            _showResultDialog(context, state);
          } else if (state is QRScannerError) {
            _showErrorSnackbar(context, state.message);
            // Reset to ready state after showing error
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.read<QRScannerBloc>().add(const ResetScannerEvent());
              }
            });
          } else if (state is QRScannerPermissionDenied) {
            _showPermissionDialog(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is QRScannerInitial) {
            return _buildLoadingView();
          } else if (state is QRScannerPermissionDenied) {
            return _buildPermissionDeniedView(context, state.message);
          }

          // Main Scanner View
          return Stack(
            children: [
              // 1. Camera
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final String? qrData = barcodes.first.rawValue;
                    if (qrData != null && qrData.isNotEmpty) {
                      context.read<QRScannerBloc>().add(
                        QRCodeScannedEvent(qrData),
                      );
                    }
                  }
                },
              ),

              // 2. Overlay (Painter)
              const ScannerOverlayWidget(),

              // 3. Top Control Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        // Title
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Quét điểm danh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Flash Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: ValueListenableBuilder(
                              valueListenable: _scannerController!,
                              builder: (context, state, child) {
                                return Icon(
                                  state.torchState == TorchState.on
                                      ? Icons.flash_on
                                      : Icons.flash_off,
                                  color: Colors.white,
                                );
                              },
                            ),
                            onPressed: () => _scannerController?.toggleTorch(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Instructions & Offline Indicator
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (state is QRScannerScanning)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Đang xử lý...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Đưa mã QR vào khung để quét',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    OfflineIndicatorWidget(
                      isOnline: state is QRScannerReady ? state.isOnline : true,
                      pendingScans: state is QRScannerReady
                          ? state.pendingOfflineScans
                          : 0,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
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
      ),
    );
  }

  Widget _buildPermissionDeniedView(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.perm_camera_mic_outlined, // Better icon
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Yêu cầu quyền truy cập',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
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
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quyền truy cập'),
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
