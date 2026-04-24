import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';
import 'package:fruitstime/features/auth/domain/usecase/get_me.dart';
import 'package:fruitstime/features/auth/domain/usecase/logout.dart';
import 'package:fruitstime/features/auth/domain/usecase/update_profile.dart';

final userProvider = NotifierProvider(_UserNotifier.new);

class _UserNotifier extends Notifier<RequestState<UserEntity>> {
  @override
  RequestState<UserEntity> build() => RequestState.idle();

  Future<void> getMe() async {
    try {
      state = RequestState.loading();

      final data = await ref.read(getMeProvider).call();

      state = RequestState.data(data);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  Future<void> updateProfile({String? birthday, int? weight, int? height}) async {
    try {
      await ref
          .read(updateProfileProvider)
          .call(birthday: birthday, weight: weight, height: height);
      final data = await ref.read(getMeProvider).call();

      state = RequestState.data(data);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }

  void logout() {
    ref.read(logoutProvider).call();
    state = RequestState.idle();
  }
}
