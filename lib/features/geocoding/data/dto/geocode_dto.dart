/// A human-readable address name extracted from a Yandex HTTP Geocoder response.
/// `name` is the place/street line; `description` (city, country) is the fallback.
class GeocodeDto {
  final String name;

  GeocodeDto({required this.name});

  factory GeocodeDto.fromJson(Map<String, dynamic> json) {
    final members =
        json['response']['GeoObjectCollection']['featureMember'] as List<dynamic>;

    for (final member in members) {
      final geoObject = member['GeoObject'] as Map<String, dynamic>;

      final name = geoObject['name'] as String?;
      if (name != null && name.isNotEmpty) return GeocodeDto(name: name);

      final description = geoObject['description'] as String?;
      if (description != null && description.isNotEmpty) return GeocodeDto(name: description);
    }

    return GeocodeDto(name: '');
  }
}
