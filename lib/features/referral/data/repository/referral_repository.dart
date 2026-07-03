import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/referral/data/dto/referral_status_dto.dart';

final referralRepositoryProvider = Provider(
  (ref) => ReferralRepository(ref.read(apiClientProvider)),
);

class ReferralRepository {
  final Dio _client;

  ReferralRepository(this._client);

  Future<ReferralStatusDto> getStatus() async {
    final response = await _client.get('user/me/referral');
    return ReferralStatusDto.parse(response.data as Map<String, dynamic>);
  }
}
