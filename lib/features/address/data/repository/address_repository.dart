import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/address/data/dto/address_dto.dart';

final addressRepositoryProvider = Provider((ref) => AddressRepository(ref.read(apiClientProvider)));

class AddressRepository {
  final Dio _client;

  AddressRepository(this._client);

  Future<List<AddressDto>> getMine() async {
    final response = await _client.get('address');
    final data = response.data as List<dynamic>;

    return data.map((e) => AddressDto.parse(e)).toList();
  }

  Future<AddressDto> create({
    required String name,
    required double lat,
    required double long,
  }) async {
    final response = await _client.post('address', data: {'name': name, 'lat': lat, 'long': long});

    return AddressDto.parse(response.data);
  }

  Future<void> delete(String id) async {
    await _client.delete('address/$id');
  }
}
