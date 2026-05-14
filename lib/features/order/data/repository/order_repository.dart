import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/order/data/dto/order_dto.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.read(apiClientProvider)));

class OrderRepository {
  final Dio _client;

  OrderRepository(this._client);

  Future<List<OrderDto>> getMine() async {
    final response = await _client.get('order');
    final data = response.data as List<dynamic>;

    return data.map((e) => OrderDto.parse(e)).toList();
  }

  Future<OrderDto> create(List<Map<String, dynamic>> items, {String? branchId}) async {
    // ignore: use_null_aware_elements
    final body = {'items': items, if (branchId != null) 'branchId': branchId};
    final response = await _client.post('order', data: body);

    return OrderDto.parse(response.data);
  }
}
