import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/catalog/domain/usecase/get_catalogs.dart';

final catalogsProvider = NotifierProvider(_CatalogsNotifier.new);

class _CatalogsNotifier extends Notifier<RequestState<List<CatalogEntity>>> {
  @override
  RequestState<List<CatalogEntity>> build() => RequestState.idle();

  Future<void> getAll() async {
    try {
      state = RequestState.loading();
      state = RequestState.data(await ref.read(getCatalogsProvider).call());
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
