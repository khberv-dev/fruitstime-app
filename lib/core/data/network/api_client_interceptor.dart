import 'package:dio/dio.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';

class ApiClientInterceptor extends Interceptor {
  final CacheService _cache;
  final Dio _client;

  ApiClientInterceptor(this._cache, this._client);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = _cache.getAccessToken();
    final locale = _cache.getLocale() ?? 'uz';

    if (accessToken != null && !options.path.startsWith('auth')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    options.queryParameters['locale'] = locale;

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.startsWith('auth')) {
      try {
        final refreshToken = _cache.getRefreshToken();
        final response = await _client.post(
          'auth/refresh',
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
        );

        final data = response.data as Map<String, dynamic>;
        final accessToken = data['accessToken'];

        _cache.setAccessToken(accessToken);
        _cache.setRefreshToken(data['refreshToken']);

        final retryResponse = await _client.fetch(
          err.requestOptions..headers['Authorization'] = 'Bearer $accessToken',
        );

        return handler.resolve(retryResponse);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    final message = err.response?.data['message'];

    if (message != null) {
      final errorMessage = message is List<dynamic> ? message.join(', ') : message;
      return handler.next(err.copyWith(message: errorMessage));
    }

    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
