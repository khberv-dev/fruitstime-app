import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/geocoding/data/repository/geocoding_repository.dart';

final reverseGeocodeProvider = Provider(
  (ref) => ReverseGeocode(ref.read(geocodingRepositoryProvider)),
);

class ReverseGeocode {
  final GeocodingRepository _repository;

  ReverseGeocode(this._repository);

  /// Resolves coordinates to a display address name (empty when unknown).
  Future<String> call({required double lat, required double long}) async {
    final dto = await _repository.reverseGeocode(lat: lat, long: long);
    return dto.name;
  }
}
