import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final BaseUserEntity user;

  const UserProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State khi đang upload avatar
class UserProfileAvatarUploading extends UserProfileState {
  final BaseUserEntity user;

  const UserProfileAvatarUploading(this.user);

  @override
  List<Object?> get props => [user];
}

/// State khi avatar đã được upload xong
class UserProfileAvatarUpdated extends UserProfileState {
  final BaseUserEntity user;

  const UserProfileAvatarUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State khi đang cập nhật thông tin người dùng (tên, số điện thoại, v.v.)
class UserProfileUpdating extends UserProfileState {
  final BaseUserEntity user;

  const UserProfileUpdating(this.user);

  @override
  List<Object?> get props => [user];
}

/// State khi cập nhật thông tin người dùng thành công
class UserProfileUpdated extends UserProfileState {
  final BaseUserEntity user;

  const UserProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
