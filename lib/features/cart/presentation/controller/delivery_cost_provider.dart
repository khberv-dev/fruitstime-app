import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/usecase/get_delivery_cost.dart';

final deliveryCostProvider = FutureProvider.autoDispose<int?>((ref) async {
  final type = ref.watch(fulfillmentProvider);
  if (type != OrderType.delivery) return null;

  final branch = ref.watch(selectedBranchProvider);
  final address = ref.watch(selectedAddressProvider);
  if (branch == null || address == null) return null;

  return ref.read(getDeliveryCostProvider).call(branchId: branch.id, addressId: address.id);
});
