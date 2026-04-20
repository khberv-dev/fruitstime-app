import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/auth_verify_repository.dart';

final verifyPhoneOtpProvider = Provider(
  (ref) => VerifyPhoneOtp(ref.read(authVerifyRepositoryProvider)),
);

class VerifyPhoneOtp {
  final AuthVerifyRepository _repository;

  VerifyPhoneOtp(this._repository);

  Future<bool> call({required String sessionId, required String code}) async {
    return _repository.verifyOtp(sessionId: sessionId, code: code);
  }
}
