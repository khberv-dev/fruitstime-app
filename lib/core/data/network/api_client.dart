import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/core/data/network/api_client_interceptor.dart';
import 'package:fruitstime/core/data/network/config.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final _dioOptions = BaseOptions(
  baseUrl: baseApiUrl,
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 120),
);

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(_dioOptions);
  final cache = ref.read(cacheProvider);
  final apiClientInterceptor = ApiClientInterceptor(cache, dio);
  final talker = Talker();

  dio.interceptors.add(apiClientInterceptor);
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(printRequestHeaders: true),
    ),
  );

  return dio;
});
