import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
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

      final order = await ref.read(createOrderProvider).call(cart);

      state = RequestState.data(order);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  void reset() {
    state = RequestState.idle();
  }
}
