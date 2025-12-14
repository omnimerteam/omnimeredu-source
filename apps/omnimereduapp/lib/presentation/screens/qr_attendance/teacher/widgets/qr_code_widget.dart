import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../core/theme/qr_theme.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget hiển thị QR Code với logo
class BrandedQRCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final String? logoPath;

  const BrandedQRCodeWidget({
    Key? key,
    required this.data,
    this.size = QRAttendanceTheme.qrSize,
    this.logoPath = 'assets/images/logo/Pictorial_mark_logo.jpeg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: QRAttendanceTheme.qrCardDecoration(isDark),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        backgroundColor: QRAttendanceTheme.qrBackground,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.primary,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: QRAttendanceTheme.qrForeground,
        ),
        embeddedImage: logoPath != null ? AssetImage(logoPath!) : null,
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(size * 0.25, size * 0.25),
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}

