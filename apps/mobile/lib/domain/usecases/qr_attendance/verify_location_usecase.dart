import 'package:equatable/equatable.dart';
import 'package:mobile/services/qr_service/location_service.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/qr_attendance/location_entity.dart';
import '../../repositories/attendance/qr_attendance_repository.dart';

/// Usecase để verify location
class VerifyLocationUseCase
    extends UseCase<Either<Failure, bool>, VerifyLocationParams> {
  final QRAttendanceRepository _repository;
  final LocationService _locationService;

  VerifyLocationUseCase(this._repository, this._locationService);

  /// Execute usecase
  /// Returns true if location is valid, false otherwise
  @override
  Future<Either<Failure, bool>> call(VerifyLocationParams params) async {
    try {
      AppLogger.info(
        'Usecase: Verifying location for attendance ${params.attendanceId}',
      );

      // Get current location
      final LocationEntity userLocation = await _locationService
          .getCurrentLocation();

      // Calculate distance
      final double distance = _locationService.calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        params.schoolLatitude,
        params.schoolLongitude,
      );

      AppLogger.info('Distance from school: ${distance.toStringAsFixed(2)}m');

      // Check if within radius
      final bool isWithinRadius = distance <= params.allowedRadiusInMeters;

      if (!isWithinRadius) {
        AppLogger.warning(
          'Location verification failed. Distance: ${distance.toStringAsFixed(2)}m, '
          'Allowed: ${params.allowedRadiusInMeters}m',
        );
      }

      return Right(isWithinRadius);
    } catch (e) {
      AppLogger.error('Usecase: Failed to verify location', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}

class VerifyLocationParams extends Equatable {
  final String attendanceId;
  final double schoolLatitude;
  final double schoolLongitude;
  final double allowedRadiusInMeters;

  const VerifyLocationParams({
    required this.attendanceId,
    required this.schoolLatitude,
    required this.schoolLongitude,
    required this.allowedRadiusInMeters,
  });

  @override
  List<Object?> get props => [
    attendanceId,
    schoolLatitude,
    schoolLongitude,
    allowedRadiusInMeters,
  ];
}
