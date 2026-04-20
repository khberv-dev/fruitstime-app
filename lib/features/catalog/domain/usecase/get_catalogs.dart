import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/catalog/data/repository/catalog_repository.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';

final getCatalogsProvider = Provider((ref) => GetCatalogs(ref.read(catalogRepositoryProvider)));

class GetCatalogs {
  final CatalogRepository _repository;

  GetCatalogs(this._repository);

  Future<List<CatalogEntity>> call() async {
    final data = await _repository.getAll();

    return data.map((element) => element.toEntity()).toList();
  }
}
