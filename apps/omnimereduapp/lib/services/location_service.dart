import 'package:geolocator/geolocator.dart';
import '../domain/entities/qr_attendance/location_entity.dart';

/// Service để xử lý GPS và vị trí
class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location
  Future<LocationEntity> getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // Check permission
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedForeverException();
    }

    // Get position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }

  /// Calculate distance between two locations in meters
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if location is within allowed radius
  bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double targetLat,
    required double targetLon,
    required double radiusInMeters,
  }) {
    double distance = calculateDistance(userLat, userLon, targetLat, targetLon);
    return distance <= radiusInMeters;
  }
}

// Custom exceptions
class LocationServiceDisabledException implements Exception {
  @override
  String toString() => 'Location services are disabled. Please enable location services.';
}

class LocationPermissionDeniedException implements Exception {
  @override
  String toString() => 'Location permissions are denied. Please grant location permission.';
}

class LocationPermissionDeniedForeverException implements Exception {
  @override
  String toString() => 'Location permissions are permanently denied. Please enable in settings.';
}

