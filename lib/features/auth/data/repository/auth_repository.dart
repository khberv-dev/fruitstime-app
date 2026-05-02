import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(apiClientProvider)));

class AuthRepository {
  final Dio _client;

  AuthRepository(this._client);

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String phoneNumber,
    required String password,
    String? referralCode,
  }) async {
    final response = await _client.post(
      'auth/sign-up',
      data: {
        'firstName': firstName,
        'phoneNumber': phoneNumber,
        'password': password,
        if (referralCode != null) 'referralCode': referralCode,
      },
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _client.post(
      'auth/sign-in',
      data: {'phoneNumber': phoneNumber, 'password': password},
    );

    return response.data as Map<String, dynamic>;
  }
}
