import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/banner/data/dto/banner_dto.dart';

final bannerRepositoryProvider = Provider((ref) => BannerRepository(ref.read(apiClientProvider)));

class BannerRepository {
  final Dio _client;

  BannerRepository(this._client);

  Future<List<BannerDto>> getAll() async {
    final response = await _client.get('banner');
    final data = response.data as List<dynamic>;

    return data.map((element) => BannerDto.parse(element)).toList();
  }
}
