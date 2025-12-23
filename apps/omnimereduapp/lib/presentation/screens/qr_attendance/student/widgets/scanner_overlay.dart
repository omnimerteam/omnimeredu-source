import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/qr_theme.dart';

/// Widget overlay cho scanner camera với khung quét
class ScannerOverlayWidget extends StatelessWidget {
  final double scanAreaSize;

  const ScannerOverlayWidget({
    Key? key,
    this.scanAreaSize = QRAttendanceTheme.scannerFrameSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scanAreaTop = (screenSize.height - scanAreaSize) / 2;
    final scanAreaLeft = (screenSize.width - scanAreaSize) / 2;
    // Màu xám mờ đậm hơn để khung nổi bật
    final overlayColor = Colors.black.withOpacity(0.6);

    return Stack(
      children: [
        // Top overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: scanAreaTop,
          child: Container(color: overlayColor),
        ),
        // Bottom overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: scanAreaTop,
          child: Container(color: overlayColor),
        ),
        // Left overlay
        Positioned(
          top: scanAreaTop,
          bottom: scanAreaTop,
          left: 0,
          width: scanAreaLeft,
          child: Container(color: overlayColor),
        ),
        // Right overlay
        Positioned(
          top: scanAreaTop,
          bottom: scanAreaTop,
          right: 0,
          width: scanAreaLeft,
          child: Container(color: overlayColor),
        ),
        // Scan frame with corners
        Center(
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4FC3F7), width: 2),
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
          bottom: 120,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF424242).withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Đưa mã QR vào khung để quét',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
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
