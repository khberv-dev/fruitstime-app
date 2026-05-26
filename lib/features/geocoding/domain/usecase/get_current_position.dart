import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum LocationFailure { serviceDisabled, permissionDenied }

class LocationException implements Exception {
  final LocationFailure failure;

  LocationException(this.failure);
}

final getCurrentPositionProvider = Provider((ref) => GetCurrentPosition());

/// Resolves the device's current GPS position, handling location-service and
/// permission checks. Throws [LocationException] when unavailable.
class GetCurrentPosition {
  Future<({double lat, double long})> call() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationException(LocationFailure.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationException(LocationFailure.permissionDenied);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return (lat: position.latitude, long: position.longitude);
  }
}
