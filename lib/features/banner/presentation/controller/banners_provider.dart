import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';
import 'package:fruitstime/features/banner/domain/usecase/get_banners.dart';

final bannersProvider = NotifierProvider(_BannersNotifier.new);

class _BannersNotifier extends Notifier<RequestState<List<BannerEntity>>> {
  @override
  RequestState<List<BannerEntity>> build() => RequestState.idle();

  Future<void> getAll() async {
    try {
      state = RequestState.loading();
      state = RequestState.data(await ref.read(getBannersProvider).call());
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
