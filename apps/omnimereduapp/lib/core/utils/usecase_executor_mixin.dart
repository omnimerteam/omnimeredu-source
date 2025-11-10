import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

final logger = Logger();

mixin UseCaseExecutorMixin {
  Future<void> executeUseCase<T>({
    required Future<dynamic> Function() call,
    required Emitter emit,
    required Function(T data) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      final result = await call();
      if (result.success && result.data != null) {
        onSuccess(result.data);
      } else {
        onError(result.message ?? 'Đã có lỗi xảy ra');
      }
    } catch (e, s) {
      logger.e('UseCase error', error: e, stackTrace: s);
      onError(e.toString());
    }
  }
}
