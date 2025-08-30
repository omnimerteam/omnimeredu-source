import 'package:flutter_ios_android_platforms/core/utils/logger.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.roleName,
    required super.roleKey,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    logger.i("UserModel.fromJson: $json");
    final user = json["user"];
    return UserModel(
      id: user["_id"],
      fullName: user["fullName"],
      roleName: user["roleId"]["name"],
      roleKey: user["roleKey"],
      avatarUrl: user["avatarUrl"],
    );
  }
}
