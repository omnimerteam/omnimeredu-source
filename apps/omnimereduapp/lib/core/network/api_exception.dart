class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException: $message (code: $statusCode)";
}

class NetworkException extends ApiException {
  NetworkException([String message = "No internet connection"])
    : super(message);
}

class TimeoutException extends ApiException {
  TimeoutException([String message = "Request timeout"]) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = "Kh"])
    : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = "Resource not found"])
    : super(message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException([String message = "Internal server error"])
    : super(message, statusCode: 500);
}
