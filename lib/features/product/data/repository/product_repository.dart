import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/product/data/dto/product_dto.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository(ref.read(apiClientProvider)));

class ProductRepository {
  final Dio _client;

  ProductRepository(this._client);

  Future<List<ProductDto>> getByCatalogId(String catalogId) async {
    final response = await _client.get('catalog/$catalogId/product');
    final data = response.data as List<dynamic>;

    return data.map((element) => ProductDto.parse(element)).toList();
  }

  Future<List<ProductDto>> getBySearchKey(String search) async {
    final response = await _client.get('catalog/c/product/search?search=$search');
    final data = response.data as List<dynamic>;

    return data.map((element) => ProductDto.parse(element)).toList();
  }
}
