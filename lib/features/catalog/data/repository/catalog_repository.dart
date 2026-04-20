import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/catalog/data/dto/catalog_dto.dart';

final catalogRepositoryProvider = Provider((ref) => CatalogRepository(ref.read(apiClientProvider)));

class CatalogRepository {
  final Dio _client;

  CatalogRepository(this._client);

  Future<List<CatalogDto>> getAll() async {
    final response = await _client.get('catalog');
    final data = response.data as List<dynamic>;

    return data.map((element) => CatalogDto.parse(element)).toList();
  }
}
