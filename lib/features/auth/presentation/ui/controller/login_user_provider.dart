import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/usecase/sign_in_user.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';

final loginUserProvider = NotifierProvider(_LoginUserNotifier.new);

class _LoginUserNotifier extends Notifier<RequestState<bool>> {
  @override
  RequestState<bool> build() => RequestState.idle();

  Future<void> login(String phoneNumber, String password) async {
    try {
      state = RequestState.loading();

      await ref.read(signInUserProvider).call(phoneNumber: phoneNumber, password: password);

      await ref.read(userProvider.notifier).getMe();
      state = RequestState.data(true);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
