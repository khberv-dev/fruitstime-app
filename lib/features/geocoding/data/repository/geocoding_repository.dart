import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/geocoding/data/dto/geocode_dto.dart';

final geocodingRepositoryProvider = Provider((ref) => GeocodingRepository());

class GeocodingRepository {
  final _dio = Dio();

  Future<GeocodeDto> reverseGeocode({required double lat, required double long}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      geocoderBaseUrl,
      queryParameters: {
        'apikey': yandexGeocoderApiKey,
        'geocode': '$lat,$long',
        'sco': 'latlong',
        'format': 'json',
        'lang': 'uz_UZ',
        'results': '1',
      },
    );

    return GeocodeDto.fromJson(response.data!);
  }
}
