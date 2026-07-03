import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/model/register_session.dart';
import 'package:fruitstime/features/auth/domain/usecase/sign_up_user.dart';
import 'package:fruitstime/features/auth/domain/usecase/verify_phone_otp.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/loyalty/presentation/controller/loyalty_status_provider.dart';
import 'package:fruitstime/features/referral/presentation/controller/referral_status_provider.dart';

final registerUserProvider = NotifierProvider(_RegisterUserNotifier.new);

class _RegisterUserNotifier extends Notifier<RequestState<bool>> {
  @override
  RequestState<bool> build() => RequestState.idle();

  Future<void> register(RegisterSession session, String code) async {
    try {
      state = RequestState.loading();

      await ref.read(verifyPhoneOtpProvider).call(sessionId: session.sessionId, code: code);
      await ref.read(signUpUserProvider).call(session);
      await ref.read(userProvider.notifier).getMe();
      await ref.read(loyaltyStatusProvider.notifier).getStatus();
      await ref.read(referralStatusProvider.notifier).getStatus();

      state = RequestState.data(true);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
