import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/qr_theme.dart';

/// Widget overlay cho scanner camera với khung quét và hiệu ứng animation
class ScannerOverlayWidget extends StatefulWidget {
  final double scanAreaSize;

  const ScannerOverlayWidget({
    Key? key,
    this.scanAreaSize = QRAttendanceTheme.scannerFrameSize,
  }) : super(key: key);

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: ScannerOverlayPainter(
            scanAreaSize: widget.scanAreaSize,
            scanLinePosition: _animation.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final double scanLinePosition;

  ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.scanLinePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaHalf = scanAreaSize / 2;
    final Offset center = size.center(Offset.zero);

    final Rect scanRect = Rect.fromCenter(
      center: center,
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // 1. Draw Dark Overlay with Hole
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path scanPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(20)));

    final Path overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      scanPath,
    );

    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, backgroundPaint);

    // 2. Draw Corners
    final Paint cornerPaint = Paint()
      ..color = QRAttendanceTheme.scannerCorner
      ..style = PaintingStyle.stroke
      ..strokeWidth = QRAttendanceTheme.cornerWidth
      ..strokeCap = StrokeCap.round;

    final double cornerLen = QRAttendanceTheme.cornerLength;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(scanRect.left, scanRect.top + cornerLen)
        ..lineTo(scanRect.left, scanRect.top)
        ..lineTo(scanRect.left + cornerLen, scanRect.top),
      cornerPaint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(scanRect.right - cornerLen, scanRect.top)
        ..lineTo(scanRect.right, scanRect.top)
        ..lineTo(scanRect.right, scanRect.top + cornerLen),
      cornerPaint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(scanRect.left, scanRect.bottom - cornerLen)
        ..lineTo(scanRect.left, scanRect.bottom)
        ..lineTo(scanRect.left + cornerLen, scanRect.bottom),
      cornerPaint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(scanRect.right - cornerLen, scanRect.bottom)
        ..lineTo(scanRect.right, scanRect.bottom)
        ..lineTo(scanRect.right, scanRect.bottom - cornerLen),
      cornerPaint,
    );

    // 3. Draw Scanning Line (Animated)
    final Paint linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          QRAttendanceTheme.scannerCorner.withOpacity(0),
          QRAttendanceTheme.scannerCorner,
          QRAttendanceTheme.scannerCorner.withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(scanRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double currentY = scanRect.top + (scanRect.height * scanLinePosition);

    // Draw line only if within rect height (logic is implicit by calculation)
    canvas.drawLine(
      Offset(scanRect.left + 10, currentY),
      Offset(scanRect.right - 10, currentY),
      linePaint,
    );

    // Soft glow for line
    final Paint glowPaint = Paint()
      ..color = QRAttendanceTheme.scannerCorner.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawRect(
      Rect.fromLTWH(scanRect.left, currentY - 5, scanRect.width, 10),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanLinePosition != scanLinePosition ||
        oldDelegate.scanAreaSize != scanAreaSize;
  }
}
