import 'package:flutter_ios_android_platforms/domain/entities/user/registered_extra_fee_entity.dart';

class RegisteredExtraFeeModel extends RegisteredExtraFeeEntity {
  const RegisteredExtraFeeModel({
    required super.extraFeeId,
    required super.amount,
  });

  /// Parse từ JSON
  factory RegisteredExtraFeeModel.fromJson(Map<String, dynamic> json) {
    return RegisteredExtraFeeModel(
      extraFeeId: json['extraFeeId'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {'extraFeeId': extraFeeId, 'amount': amount};
  }

  /// Chuyển sang Entity (ở đây chính là Entity cha)
  RegisteredExtraFeeEntity toEntity() {
    return RegisteredExtraFeeEntity(extraFeeId: extraFeeId, amount: amount);
  }

  /// Chuyển từ Entity sang Model
  factory RegisteredExtraFeeModel.fromEntity(RegisteredExtraFeeEntity entity) {
    return RegisteredExtraFeeModel(
      extraFeeId: entity.extraFeeId,
      amount: entity.amount,
    );
  }
}
