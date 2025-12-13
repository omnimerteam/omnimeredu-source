import 'errors/failures.dart';
import 'utils/either.dart';
import 'package:dartz/dartz.dart';

/// Type definition for Either<Failure, T>
typedef FutureResult<T> = Future<Either<Failure, T>>;