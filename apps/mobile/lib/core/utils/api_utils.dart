import '../api/api_exception.dart';
import '../error/failures.dart';
import 'either.dart';

Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return Right(await apiCall());
  } on Failure catch (e) {
    return Left(e);
  } on TimeoutException catch (e) {
    return Left(TimeoutFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on UnauthorizedException catch (e) {
    return Left(AuthFailure(e.message));
  } on ForbiddenException catch (e) {
    return Left(AuthFailure(e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on ApiException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
