import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/catalog/presentation/controller/selected_catalog_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/domain/usecase/get_products.dart';

final productsProvider = NotifierProvider(_ProductsNotifier.new);

class _ProductsNotifier extends Notifier<RequestState<List<ProductEntity>>> {
  @override
  RequestState<List<ProductEntity>> build() => RequestState.idle();

  Future<void> getByCatalog() async {
    try {
      state = RequestState.loading();

      final selectedCatalog = ref.read(selectedCatalogProvider);
      final products = await ref.read(getProductsProvider).call(selectedCatalog!.id);

      state = RequestState.data(products);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
