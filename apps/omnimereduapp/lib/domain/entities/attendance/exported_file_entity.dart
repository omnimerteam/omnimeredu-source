import 'package:equatable/equatable.dart';

class ExportedFileEntity extends Equatable {
  final String mode;
  final String fileName;
  final String mimeType;
  final String base64Data;

  const ExportedFileEntity({
    required this.mode,
    required this.fileName,
    required this.mimeType,
    required this.base64Data,
  });

  @override
  List<Object?> get props => [mode, fileName, mimeType, base64Data];
}
