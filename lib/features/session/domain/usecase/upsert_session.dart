import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/features/session/data/repository/session_repository.dart';

final upsertSessionProvider = Provider(
  (ref) => UpsertSession(ref.read(sessionRepositoryProvider), ref.read(cacheProvider)),
);

class UpsertSession {
  final SessionRepository _repository;
  final CacheService _cache;

  StreamSubscription<String>? _tokenRefreshSub;

  UpsertSession(this._repository, this._cache);

  Future<void> call() async {
    try {
      // Always listen for token refresh — fires when token rotates or when
      // APNs registers for the first time (covers the "not ready yet" case).
      _tokenRefreshSub?.cancel();
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) => _sendRequest(token),
      );

      // On iOS, APNs token is set asynchronously. Poll until it is ready
      // (typically within 1–2 s on a real device) before fetching the FCM token.
      if (Platform.isIOS) {
        String? apnsToken;
        for (int i = 0; i < 10; i++) {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) break;
          await Future.delayed(const Duration(seconds: 1));
        }
        if (apnsToken == null) {
          // ignore: avoid_print
          print('[Session] APNs token unavailable after retries');
          return;
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _sendRequest(token);
    } catch (e, st) {
      // ignore: avoid_print
      print('[Session] setup error: $e\n$st');
    }
  }

  Future<void> _sendRequest(String token) async {
    try {
      final os = Platform.isIOS ? 'ios' : 'android';
      final storedId = _cache.getSessionId();

      if (storedId != null) {
        try {
          await _repository.update(fcmToken: token, os: os);
          // ignore: avoid_print
          print('[Session] updated session $storedId');
          return;
        } catch (e) {
          // ignore: avoid_print
          print('[Session] update failed ($e) — falling back to create');
          _cache.clearSessionId();
        }
      }

      final id = await _repository.create(fcmToken: token, os: os);
      _cache.setSessionId(id);
      // ignore: avoid_print
      print('[Session] created session $id');
    } catch (e, st) {
      // ignore: avoid_print
      print('[Session] request error: $e\n$st');
    }
  }
}
