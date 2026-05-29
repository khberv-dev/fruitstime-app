import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/features/address/domain/entity/address_entity.dart';

final selectedAddressProvider = NotifierProvider<_SelectedAddressNotifier, AddressEntity?>(
  _SelectedAddressNotifier.new,
);

class _SelectedAddressNotifier extends Notifier<AddressEntity?> {
  @override
  AddressEntity? build() => null;

  /// Re-resolves the persisted default against a freshly loaded list. Unlike
  /// branch selection, no address is auto-picked — delivery requires an
  /// explicit choice.
  void resolve(List<AddressEntity> addresses) {
    final savedId = ref.read(cacheProvider).getSelectedAddressId();
    AddressEntity? match;
    for (final address in addresses) {
      if (address.id == savedId) {
        match = address;
        break;
      }
    }
    state = match;
  }

  void select(AddressEntity address) {
    ref.read(cacheProvider).setSelectedAddressId(address.id);
    state = address;
  }

  void onRemoved(String removedId) {
    if (state?.id == removedId) {
      ref.read(cacheProvider).clearSelectedAddressId();
      state = null;
    }
  }
}
