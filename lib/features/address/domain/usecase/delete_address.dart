import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/address/data/repository/address_repository.dart';

final deleteAddressProvider = Provider((ref) => DeleteAddress(ref.read(addressRepositoryProvider)));

class DeleteAddress {
  final AddressRepository _repository;

  DeleteAddress(this._repository);

  Future<void> call(String id) => _repository.delete(id);
}
