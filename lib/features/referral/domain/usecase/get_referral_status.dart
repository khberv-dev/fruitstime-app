import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/referral/data/repository/referral_repository.dart';
import 'package:fruitstime/features/referral/domain/entity/referral_status_entity.dart';

final getReferralStatusProvider = Provider(
  (ref) => GetReferralStatus(ref.read(referralRepositoryProvider)),
);

class GetReferralStatus {
  final ReferralRepository _repository;

  GetReferralStatus(this._repository);

  Future<ReferralStatusEntity> call() async {
    final dto = await _repository.getStatus();
    return dto.toEntity();
  }
}
