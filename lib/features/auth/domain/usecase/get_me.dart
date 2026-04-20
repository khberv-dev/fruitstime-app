import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/user_repository.dart';
import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';

final getMeProvider = Provider((ref) => GetMe(ref.read(userRepositoryProvider)));

class GetMe {
  final UserRepository _repository;

  GetMe(this._repository);

  Future<UserEntity> call() async {
    final data = await _repository.getMe();

    return data.toEntity();
  }
}
