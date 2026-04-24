import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/product/data/repository/product_repository.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final searchProductsProvider = Provider(
  (ref) => SearchProducts(ref.read(productRepositoryProvider)),
);

class SearchProducts {
  final ProductRepository _repository;

  SearchProducts(this._repository);

  Future<List<ProductEntity>> call(String search) async {
    final data = await _repository.getBySearchKey(search);

    return data.map((element) => element.toEntity()).toList();
  }
}
