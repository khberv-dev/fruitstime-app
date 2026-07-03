import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_evaluation_entity.dart';
import 'package:fruitstime/features/order/domain/usecase/evaluate_order.dart';

final orderEvaluationProvider = FutureProvider.autoDispose<OrderEvaluationEntity?>((ref) async {
  final cart = ref.watch(cartProvider);
  if (cart.isEmpty) return null;

  final branch = ref.watch(selectedBranchProvider);
  if (branch == null) return null;

  final type = ref.watch(fulfillmentProvider);
  final isDelivery = type == OrderType.delivery;
  final address = ref.watch(selectedAddressProvider);

  if (isDelivery && address == null) return null;

  return ref
      .read(evaluateOrderProvider)
      .call(cart, branchId: branch.id, type: type, addressId: isDelivery ? address!.id : null);
});
