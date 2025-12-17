import 'dart:math';
import 'package:equatable/equatable.dart';

/// Entity cho vị trí GPS
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy, timestamp];

  /// Calculate distance to another location in meters using Haversine formula
  double distanceTo(LocationEntity other) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = latitude * pi / 180;
    final lat2Rad = other.latitude * pi / 180;
    final deltaLat = (other.latitude - latitude) * pi / 180;
    final deltaLon = (other.longitude - longitude) * pi / 180;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLon / 2) * sin(deltaLon / 2);
    
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  @override
  String toString() {
    return 'LocationEntity(lat: $latitude, lon: $longitude, accuracy: $accuracy)';
  }
}

