import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;
  final double size;

  const QRCodeWidget({Key? key, required this.data, this.size = 200})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size.w,
        backgroundColor: Colors.white,
      ),
    );
  }
}
