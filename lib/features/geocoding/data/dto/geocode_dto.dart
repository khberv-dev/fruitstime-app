import 'package:yandex_maps_mapkit/search.dart' show SearchResponse;

/// A human-readable address name extracted from a Yandex Search response.
/// For a reverse-geocoded point the top toponym's `name` is the street/house
/// line; `descriptionText` (district/city) is used as a fallback.
class GeocodeDto {
  final String name;

  GeocodeDto({required this.name});

  factory GeocodeDto.fromResponse(SearchResponse response) {
    for (final item in response.collection.children) {
      final geoObject = item.asGeoObject();
      if (geoObject == null) continue;

      final name = geoObject.name;
      if (name != null && name.isNotEmpty) return GeocodeDto(name: name);

      final description = geoObject.descriptionText;
      if (description != null && description.isNotEmpty) return GeocodeDto(name: description);
    }

    return GeocodeDto(name: '');
  }
}
