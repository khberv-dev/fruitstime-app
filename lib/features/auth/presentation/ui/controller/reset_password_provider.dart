import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/usecase/reset_password.dart';

final resetPasswordProvider = NotifierProvider(_ResetPasswordNotifier.new);

class _ResetPasswordNotifier extends Notifier<RequestState<bool>> {
  @override
  RequestState<bool> build() => RequestState.idle();

  Future<void> reset({required String otpId, required String password}) async {
    try {
      state = RequestState.loading();

      await ref.read(resetAccountPasswordProvider).call(otpId: otpId, password: password);

      state = RequestState.data(true);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
