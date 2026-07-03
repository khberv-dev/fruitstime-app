import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/loyalty/data/repository/loyalty_repository.dart';
import 'package:fruitstime/features/loyalty/domain/entity/loyalty_status_entity.dart';

final getLoyaltyStatusProvider = Provider(
  (ref) => GetLoyaltyStatus(ref.read(loyaltyRepositoryProvider)),
);

class GetLoyaltyStatus {
  final LoyaltyRepository _repository;

  GetLoyaltyStatus(this._repository);

  Future<LoyaltyStatusEntity> call() async {
    final dto = await _repository.getStatus();
    return dto.toEntity();
  }
}
