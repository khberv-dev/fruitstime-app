import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/address/presentation/controller/selected_address_provider.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/usecase/create_order.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final createOrderControllerProvider = NotifierProvider(_CreateOrderNotifier.new);

class _CreateOrderNotifier extends Notifier<RequestState<OrderEntity>> {
  @override
  RequestState<OrderEntity> build() => RequestState.idle();

  Future<void> create(Map<ProductEntity, int> cart) async {
    try {
      state = RequestState.loading();

      final branchId = ref.read(selectedBranchProvider)?.id;
      if (branchId == null) {
        state = RequestState.idle();
        return;
      }

      final type = ref.read(fulfillmentProvider);
      final isDelivery = type == OrderType.delivery;
      final addressId = isDelivery ? ref.read(selectedAddressProvider)?.id : null;

      if (isDelivery && addressId == null) {
        state = RequestState.idle();
        return;
      }

      final order = await ref
          .read(createOrderProvider)
          .call(cart, branchId: branchId, type: type, addressId: addressId);

      state = RequestState.data(order);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  void reset() {
    state = RequestState.idle();
  }
}
