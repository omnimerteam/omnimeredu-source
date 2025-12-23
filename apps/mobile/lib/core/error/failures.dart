abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  String toString() => 'Lỗi Máy Chủ: $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  String toString() => 'Lỗi Bộ Nhớ Đệm: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  String toString() => 'Lỗi Kết Nối Mạng: $message';
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);

  @override
  String toString() => 'Lỗi Xác Thực: $message';
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);

  @override
  String toString() => 'Lỗi Quá Thời Gian: $message';
}
