import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/auth_verify_repository.dart';

final checkPhoneNumberProvider = Provider(
  (ref) => CheckPhoneNumber(ref.read(authVerifyRepositoryProvider)),
);

class CheckPhoneNumber {
  final AuthVerifyRepository _repository;

  CheckPhoneNumber(this._repository);

  Future<bool> call(String phoneNumber) async {
    return _repository.checkPhoneNumber(phoneNumber);
  }
}
