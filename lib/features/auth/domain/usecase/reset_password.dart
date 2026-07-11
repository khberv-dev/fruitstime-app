import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/auth_repository.dart';

final resetAccountPasswordProvider = Provider(
  (ref) => ResetPassword(ref.read(authRepositoryProvider)),
);

class ResetPassword {
  final AuthRepository _repository;

  ResetPassword(this._repository);

  Future<void> call({required String otpId, required String password}) {
    return _repository.resetPassword(otpId: otpId, password: password);
  }
}
