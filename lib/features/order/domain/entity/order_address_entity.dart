class OrderAddressEntity {
  final double lat;
  final double long;

  /// Human-readable address (district, street) resolved via reverse geocoding.
  /// Client-side only — the backend stores coordinates, not this name.
  final String? name;

  OrderAddressEntity({required this.lat, required this.long, this.name});
}
