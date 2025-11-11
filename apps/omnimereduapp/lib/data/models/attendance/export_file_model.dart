import 'package:omnimereduapp/domain/entities/attendance/exported_file_entity.dart';

class ExportedFileModel {
  final String mode;
  final String fileName;
  final String mimeType;
  final String base64Data;

  ExportedFileModel({
    required this.mode,
    required this.fileName,
    required this.mimeType,
    required this.base64Data,
  });

  factory ExportedFileModel.fromJson(Map<String, dynamic> json) {
    return ExportedFileModel(
      mode: json['mode'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      base64Data: json['base64Data'] as String,
    );
  }

  ExportedFileEntity toEntity() {
    return ExportedFileEntity(
      mode: mode,
      fileName: fileName,
      mimeType: mimeType,
      base64Data: base64Data,
    );
  }

  factory ExportedFileModel.fromEntity(ExportedFileEntity entity) {
    return ExportedFileModel(
      mode: entity.mode,
      fileName: entity.fileName,
      mimeType: entity.mimeType,
      base64Data: entity.base64Data,
    );
  }
}
