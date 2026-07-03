import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/order/data/dto/order_dto.dart';
import 'package:fruitstime/features/order/data/dto/order_evaluation_dto.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.read(apiClientProvider)));

class OrderRepository {
  final Dio _client;

  OrderRepository(this._client);

  Future<OrderDto?> getActive() async {
    final response = await _client.get('order/active');
    if (response.data == null) return null;
    return OrderDto.parse(response.data as Map<String, dynamic>);
  }

  Future<List<OrderDto>> getMine() async {
    final response = await _client.get('order');
    final data = response.data as List<dynamic>;

    return data.map((e) => OrderDto.parse(e)).toList();
  }

  Future<OrderEvaluationDto> evaluate(
    List<Map<String, dynamic>> items, {
    required String branchId,
    required OrderType type,
    String? addressId,
  }) async {
    final body = <String, dynamic>{'branchId': branchId, 'type': type.name, 'items': items};
    if (addressId != null) body['addressId'] = addressId;

    final response = await _client.post('order/evaluate', data: body);

    return OrderEvaluationDto.parse(response.data);
  }

  Future<OrderDto> create(
    List<Map<String, dynamic>> items, {
    required String branchId,
    required OrderType type,
    String? addressId,
  }) async {
    final body = <String, dynamic>{'branchId': branchId, 'type': type.name, 'items': items};
    if (addressId != null) body['addressId'] = addressId;

    final response = await _client.post('order', data: body);

    return OrderDto.parse(response.data);
  }
}
