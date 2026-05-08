import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/usecase/get_orders.dart';

final ordersProvider = NotifierProvider(_OrdersNotifier.new);

class _OrdersNotifier extends Notifier<RequestState<List<OrderEntity>>> {
  @override
  RequestState<List<OrderEntity>> build() => RequestState.idle();

  Future<void> getMine() async {
    try {
      state = RequestState.loading();

      final orders = await ref.read(getOrdersProvider).call();

      state = RequestState.data(orders);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
