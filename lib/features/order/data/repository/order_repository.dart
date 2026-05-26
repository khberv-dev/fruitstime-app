import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/order/data/dto/order_dto.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.read(apiClientProvider)));

class OrderRepository {
  final Dio _client;

  OrderRepository(this._client);

  Future<List<OrderDto>> getMine() async {
    final response = await _client.get('order');
    final data = response.data as List<dynamic>;

    return data.map((e) => OrderDto.parse(e)).toList();
  }

  Future<OrderDto> create(
    List<Map<String, dynamic>> items, {
    required String branchId,
    required OrderType type,
    OrderAddressEntity? address,
  }) async {
    final body = {
      'branchId': branchId,
      'type': type.name,
      'items': items,
      if (address != null) 'address': {'long': address.long, 'lat': address.lat},
    };
    final response = await _client.post('order', data: body);

    return OrderDto.parse(response.data);
  }
}
