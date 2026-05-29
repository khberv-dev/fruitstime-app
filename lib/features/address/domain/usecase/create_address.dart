import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/address/data/repository/address_repository.dart';
import 'package:fruitstime/features/address/domain/entity/address_entity.dart';

final createAddressProvider = Provider((ref) => CreateAddress(ref.read(addressRepositoryProvider)));

class CreateAddress {
  final AddressRepository _repository;

  CreateAddress(this._repository);

  Future<AddressEntity> call({
    required String name,
    required double lat,
    required double long,
  }) async {
    final dto = await _repository.create(name: name, lat: lat, long: long);
    return dto.toEntity();
  }
}
