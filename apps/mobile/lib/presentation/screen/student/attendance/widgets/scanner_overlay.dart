import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class QRAttendanceTheme {
  // Sizes / Dimensions
  static const double scannerFrameSize = 280.0;
  static const double cornerLength = 30.0;
  static const double cornerWidth = 4.0;
  static const double borderRadius = 16.0;

  // Colors
  // Overlay color: black with 0.5 opacity (or similar)
  static final Color scannerOverlay = Colors.black.withOpacity(0.5);

  // Scanner Frame Colors
  static const Color scannerCorner = AppColors.primary;
  static const Color scannerBorder = Colors.white; // Or any subtle border color
}

/// Widget overlay cho scanner camera với khung quét
class ScannerOverlayWidget extends StatelessWidget {
  final double scanAreaSize;

  const ScannerOverlayWidget({
    Key? key,
    this.scanAreaSize = QRAttendanceTheme.scannerFrameSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            QRAttendanceTheme.scannerOverlay,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: scanAreaSize,
                  width: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scan frame with corners
        Center(
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Top-left corner
                _buildCorner(
                  top: 0,
                  left: 0,
                  topBorder: true,
                  leftBorder: true,
                ),
                // Top-right corner
                _buildCorner(
                  top: 0,
                  right: 0,
                  topBorder: true,
                  rightBorder: true,
                ),
                // Bottom-left corner
                _buildCorner(
                  bottom: 0,
                  left: 0,
                  bottomBorder: true,
                  leftBorder: true,
                ),
                // Bottom-right corner
                _buildCorner(
                  bottom: 0,
                  right: 0,
                  bottomBorder: true,
                  rightBorder: true,
                ),
              ],
            ),
          ),
        ),
        // Instruction text
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Đưa mã QR vào khung để quét',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool topBorder = false,
    bool bottomBorder = false,
    bool leftBorder = false,
    bool rightBorder = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: QRAttendanceTheme.cornerLength,
        height: QRAttendanceTheme.cornerLength,
        decoration: BoxDecoration(
          border: Border(
            top: topBorder
                ? BorderSide(
                    color: QRAttendanceTheme.scannerCorner,
                    width: QRAttendanceTheme.cornerWidth,
                  )
                : BorderSide.none,
            bottom: bottomBorder
                ? BorderSide(
                    color: QRAttendanceTheme.scannerCorner,
                    width: QRAttendanceTheme.cornerWidth,
                  )
                : BorderSide.none,
            left: leftBorder
                ? BorderSide(
                    color: QRAttendanceTheme.scannerCorner,
                    width: QRAttendanceTheme.cornerWidth,
                  )
                : BorderSide.none,
            right: rightBorder
                ? BorderSide(
                    color: QRAttendanceTheme.scannerCorner,
                    width: QRAttendanceTheme.cornerWidth,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
