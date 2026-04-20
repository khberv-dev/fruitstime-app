import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/banner/data/repository/banner_repository.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';

final getBannersProvider = Provider((ref) => GetBanners(ref.read(bannerRepositoryProvider)));

class GetBanners {
  final BannerRepository _repository;

  GetBanners(this._repository);

  Future<List<BannerEntity>> call() async {
    final data = await _repository.getAll();

    return data.map((element) => element.toEntity()).toList();
  }
}
