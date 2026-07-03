import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/loyalty/domain/entity/loyalty_status_entity.dart';
import 'package:fruitstime/features/loyalty/domain/usecase/get_loyalty_status.dart';

final loyaltyStatusProvider = NotifierProvider(_LoyaltyStatusNotifier.new);

class _LoyaltyStatusNotifier extends Notifier<RequestState<LoyaltyStatusEntity>> {
  @override
  RequestState<LoyaltyStatusEntity> build() => RequestState.idle();

  Future<void> getStatus() async {
    try {
      state = RequestState.loading();
      state = RequestState.data(await ref.read(getLoyaltyStatusProvider).call());
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
