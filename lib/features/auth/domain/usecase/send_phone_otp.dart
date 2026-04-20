import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/auth_verify_repository.dart';

final sendPhoneOtpProvider = Provider(
  (ref) => SendPhoneOtp(ref.read(authVerifyRepositoryProvider)),
);

class SendPhoneOtp {
  final AuthVerifyRepository _repository;

  SendPhoneOtp(this._repository);

  Future<String> call(String phoneNumber) async {
    return _repository.sendOtp(phoneNumber);
  }
}
