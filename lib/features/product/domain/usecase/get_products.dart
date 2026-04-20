import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/product/data/repository/product_repository.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final getProductsProvider = Provider((ref) => GetProducts(ref.read(productRepositoryProvider)));

class GetProducts {
  final ProductRepository _repository;

  GetProducts(this._repository);

  Future<List<ProductEntity>> call(String catalogId) async {
    final data = await _repository.getByCatalogId(catalogId);

    return data.map((element) => element.toEntity()).toList();
  }
}
