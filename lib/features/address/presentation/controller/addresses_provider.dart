import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/address/domain/entity/address_entity.dart';
import 'package:fruitstime/features/address/domain/usecase/create_address.dart';
import 'package:fruitstime/features/address/domain/usecase/delete_address.dart';
import 'package:fruitstime/features/address/domain/usecase/get_addresses.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';

final addressesProvider = NotifierProvider<_AddressesNotifier, RequestState<List<AddressEntity>>>(
  _AddressesNotifier.new,
);

class _AddressesNotifier extends Notifier<RequestState<List<AddressEntity>>> {
  @override
  RequestState<List<AddressEntity>> build() => RequestState.idle();

  Future<void> load() async {
    try {
      state = RequestState.loading();
      final addresses = await ref.read(getAddressesProvider).call();
      state = RequestState.data(addresses);
      ref.read(selectedAddressProvider.notifier).resolve(addresses);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  /// Creates an address, prepends it to the list, and selects it as default.
  Future<AddressEntity?> add({
    required String name,
    required double lat,
    required double long,
  }) async {
    try {
      final created = await ref.read(createAddressProvider).call(name: name, lat: lat, long: long);
      state = RequestState.data([created, ...?state.data]);
      ref.read(selectedAddressProvider.notifier).select(created);
      return created;
    } on DioException catch (e) {
      state = RequestState.error(e.message);
      return null;
    }
  }

  Future<void> remove(String id) async {
    try {
      await ref.read(deleteAddressProvider).call(id);
      state = RequestState.data([...?state.data?.where((a) => a.id != id)]);
      ref.read(selectedAddressProvider.notifier).onRemoved(id);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
