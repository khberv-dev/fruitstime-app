import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';

final authVerifyRepositoryProvider = Provider(
  (ref) => AuthVerifyRepository(ref.read(apiClientProvider)),
);

class AuthVerifyRepository {
  final Dio _client;

  AuthVerifyRepository(this._client);

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final response = await _client.get('auth/check/$phoneNumber');

    return response.data['status'];
  }

  Future<String> sendOtp(String phoneNumber) async {
    final response = await _client.post('auth/send-otp', data: {'phoneNumber': phoneNumber});

    return response.data['id'];
  }

  Future<bool> verifyOtp({required String sessionId, required String code}) async {
    final response = await _client.post('auth/verify-otp/$sessionId', data: {'code': code});

    return response.data['status'];
  }
}
