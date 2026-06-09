import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';

final sessionRepositoryProvider = Provider((ref) => SessionRepository(ref.read(apiClientProvider)));

class SessionRepository {
  final Dio _client;

  SessionRepository(this._client);

  /// Creates a new session. Returns the session ID from the server.
  Future<String> create({required String fcmToken, required String os}) async {
    final response = await _client.post<Map<String, dynamic>>(
      'session',
      data: {'fcmToken': fcmToken, 'os': os},
    );
    return response.data!['id'] as String;
  }

  /// Updates the existing session. Throws if no session found (404).
  Future<void> update({required String fcmToken, required String os}) async {
    await _client.patch<void>('session', data: {'fcmToken': fcmToken, 'os': os});
  }
}
