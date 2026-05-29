import 'package:fruitstime/features/address/domain/entity/address_entity.dart';

class AddressDto {
  final String id;
  final String name;
  final double lat;
  final double long;

  AddressDto({required this.id, required this.name, required this.lat, required this.long});

  factory AddressDto.parse(Map<String, dynamic> data) => AddressDto(
    id: data['id'] as String,
    name: data['name'] as String,
    lat: (data['lat'] as num).toDouble(),
    long: (data['long'] as num).toDouble(),
  );

  AddressEntity toEntity() => AddressEntity(id: id, name: name, lat: lat, long: long);
}
