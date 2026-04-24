import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/enum/gender.dart';
import 'package:fruitstime/features/auth/data/repository/user_repository.dart';

final updateProfileProvider = Provider((ref) => UpdateProfile(ref.read(userRepositoryProvider)));

class UpdateProfile {
  final UserRepository _repository;

  UpdateProfile(this._repository);

  Future<void> call({String? birthday, int? weight, int? height, Gender? gender}) async {
    await _repository.updateProfile(
      birthday: birthday,
      weight: weight,
      height: height,
      gender: gender,
    );
  }
}
