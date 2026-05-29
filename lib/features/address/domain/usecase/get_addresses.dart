import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/address/data/repository/address_repository.dart';
import 'package:fruitstime/features/address/domain/entity/address_entity.dart';

final getAddressesProvider = Provider((ref) => GetAddresses(ref.read(addressRepositoryProvider)));

class GetAddresses {
  final AddressRepository _repository;

  GetAddresses(this._repository);

  Future<List<AddressEntity>> call() async {
    final dtos = await _repository.getMine();
    return dtos.map((e) => e.toEntity()).toList();
  }
}
