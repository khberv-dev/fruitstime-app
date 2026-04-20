import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/domain/usecase/search_products.dart';

final searchProductsStateProvider = NotifierProvider(_SearchProductsProvider.new);

class _SearchProductsProvider extends Notifier<RequestState<List<ProductEntity>>> {
  @override
  RequestState<List<ProductEntity>> build() => RequestState.idle();

  Future<void> search(String search) async {
    try {
      state = RequestState.loading();

      final products = await ref.read(searchProductsProvider).call(search);

      state = RequestState.data(products);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  void clean() {
    state = RequestState.data([]);
  }
}
