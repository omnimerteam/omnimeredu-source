import 'package:logger/logger.dart';

/// Logger mặc định cho toàn app
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Không in stacktrace
    errorMethodCount: 0,
    lineLength: 100, // chiều dài tối đa 1 dòng log
    colors: true,
    printEmojis: true,
    printTime: false, // tắt giờ log nếu không cần
  ),
);

/// Logger đơn giản hơn (gọn hơn PrettyPrinter)
final simpleLogger = Logger(printer: SimplePrinter(colors: true));

/// AppLogger - Static wrapper cho logger để dùng trong toàn app
class AppLogger {
  static void info(String message) {
    logger.i(message);
  }

  static void debug(String message) {
    logger.d(message);
  }

  static void warning(String message) {
    logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void verbose(String message) {
    logger.t(message);
  }

  static void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }
}