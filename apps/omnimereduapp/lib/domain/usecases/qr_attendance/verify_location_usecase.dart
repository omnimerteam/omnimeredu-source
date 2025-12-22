import '../../../domain/repositories/qr_attendance/qr_attendance_repository.dart';
import '../../../services/location_service.dart';
import '../../../domain/entities/qr_attendance/location_entity.dart';
import '../../../core/utils/logger.dart';

/// Usecase để verify location
class VerifyLocationUsecase {
  final QRAttendanceRepository _repository;
  final LocationService _locationService;

  VerifyLocationUsecase(
    this._repository,
    this._locationService,
  );

  /// Execute usecase
  /// Returns true if location is valid, false otherwise
  Future<bool> call({
    required String attendanceId,
    required double schoolLatitude,
    required double schoolLongitude,
    required double allowedRadiusInMeters,
  }) async {
    try {
      AppLogger.info('Usecase: Verifying location for attendance $attendanceId');

      // Get current location
      final LocationEntity userLocation = await _locationService.getCurrentLocation();

      // Calculate distance
      final double distance = _locationService.calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        schoolLatitude,
        schoolLongitude,
      );

      AppLogger.info('Distance from school: ${distance.toStringAsFixed(2)}m');

      // Check if within radius
      final bool isWithinRadius = distance <= allowedRadiusInMeters;

      if (!isWithinRadius) {
        AppLogger.warning(
          'Location verification failed. Distance: ${distance.toStringAsFixed(2)}m, '
          'Allowed: ${allowedRadiusInMeters}m'
        );
      }

      return isWithinRadius;
    } catch (e) {
      AppLogger.error('Usecase: Failed to verify location', e);
      rethrow;
    }
  }
}

