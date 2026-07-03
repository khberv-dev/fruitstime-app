import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/referral/domain/entity/referral_status_entity.dart';
import 'package:fruitstime/features/referral/domain/usecase/get_referral_status.dart';

final referralStatusProvider = NotifierProvider(_ReferralStatusNotifier.new);

class _ReferralStatusNotifier extends Notifier<RequestState<ReferralStatusEntity>> {
  @override
  RequestState<ReferralStatusEntity> build() => RequestState.idle();

  Future<void> getStatus() async {
    try {
      state = RequestState.loading();
      state = RequestState.data(await ref.read(getReferralStatusProvider).call());
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
