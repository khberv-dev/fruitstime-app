import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/usecase/verify_phone_otp.dart';

final verifyResetOtpProvider = NotifierProvider(_VerifyResetOtpNotifier.new);

class _VerifyResetOtpNotifier extends Notifier<RequestState<bool>> {
  @override
  RequestState<bool> build() => RequestState.idle();

  Future<void> verify({required String sessionId, required String code}) async {
    try {
      state = RequestState.loading();

      final verified = await ref
          .read(verifyPhoneOtpProvider)
          .call(sessionId: sessionId, code: code);

      state = RequestState.data(verified);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
