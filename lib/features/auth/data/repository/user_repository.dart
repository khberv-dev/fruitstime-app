import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/auth/data/dto/user_dto.dart';
import 'package:fruitstime/features/auth/data/enum/gender.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(ref.read(apiClientProvider)));

class UserRepository {
  final Dio _client;

  UserRepository(this._client);

  Future<UserDto> getMe() async {
    final response = await _client.get('user/me');

    return UserDto.parse(response.data);
  }

  Future<void> updateProfile({String? birthday, int? weight, int? height, Gender? gender}) async {
    await _client.put(
      'user/me',
      data: {'birthday': birthday, 'weight': weight, 'height': height, 'gender': gender?.name},
    );
  }
}
