import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/order/data/dto/order_dto.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.read(apiClientProvider)));

class OrderRepository {
  final Dio _client;

  OrderRepository(this._client);

  Future<List<OrderDto>> getMine({int page = 1, int pageSize = 20}) async {
    final response = await _client.get(
      'order',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    final data = response.data['orders'] as List<dynamic>;

    return data.map((e) => OrderDto.parse(e)).toList();
  }

  Future<OrderDto> create(List<Map<String, dynamic>> items) async {
    final response = await _client.post('order', data: {'items': items});

    return OrderDto.parse(response.data);
  }
}
