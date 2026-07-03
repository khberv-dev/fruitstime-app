import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/loyalty/data/dto/loyalty_status_dto.dart';

final loyaltyRepositoryProvider = Provider((ref) => LoyaltyRepository(ref.read(apiClientProvider)));

class LoyaltyRepository {
  final Dio _client;

  LoyaltyRepository(this._client);

  Future<LoyaltyStatusDto> getStatus() async {
    final response = await _client.get('promotion/loyalty-status');
    return LoyaltyStatusDto.parse(response.data as Map<String, dynamic>);
  }
}
