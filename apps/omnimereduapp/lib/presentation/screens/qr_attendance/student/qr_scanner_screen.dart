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
  double _zoomLevel = 1.0;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.1).clamp(1.0, 5.0);
      try {
        _scannerController?.setZoomScale(_zoomLevel);
      } catch (e) {
        // Zoom might not be supported on all devices
        // Fallback: just update the UI indicator
      }
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.1).clamp(1.0, 5.0);
      try {
        _scannerController?.setZoomScale(_zoomLevel);
      } catch (e) {
        // Zoom might not be supported on all devices
        // Fallback: just update the UI indicator
      }
    });
  }

  void _toggleTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
      _scannerController?.toggleTorch();
    });
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    context.read<QRScannerBloc>().add(const DisposeScannerEvent());
    super.dispose();
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
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleTorch,
            tooltip: _isTorchOn ? 'Tắt đèn flash' : 'Bật đèn flash',
          ),
        ],
      ),
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
          } else if (state is QRScannerScanning) {
            return _buildScanningView();
          }

          // Default scanner view
          return _buildScannerView(context, state);
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

  Widget _buildScannerView(BuildContext context, QRScannerState state) {
    final isOnline = state is QRScannerReady ? state.isOnline : true;
    final pendingScans = state is QRScannerReady
        ? state.pendingOfflineScans
        : 0;

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
                context.read<QRScannerBloc>().add(QRCodeScannedEvent(qrData));
              }
            }
          },
        ),
        // Overlay
        const ScannerOverlayWidget(),
        // Zoom controls on the right
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom in button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _zoomIn,
                  tooltip: 'Phóng to',
                ),
              ),
              const SizedBox(height: 8),
              // Zoom out button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: _zoomOut,
                  tooltip: 'Thu nhỏ',
                ),
              ),
              const SizedBox(height: 8),
              // Zoom level indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _zoomLevel == 1.0
                      ? '1:1'
                      : '${_zoomLevel.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Offline indicator at bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: OfflineIndicatorWidget(
            isOnline: isOnline,
            pendingScans: pendingScans,
          ),
        ),
      ],
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
