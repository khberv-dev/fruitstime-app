import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/features/auth/domain/entity/status_tier_entity.dart';

class StatusTierDto {
  final Tier status;
  final int minReferrals;
  final int discountPercent;

  StatusTierDto({required this.status, required this.minReferrals, required this.discountPercent});

  factory StatusTierDto.parse(Map<String, dynamic> data) => StatusTierDto(
    status: Tier.values.byName(data['status']),
    minReferrals: data['minReferrals'],
    discountPercent: data['discountPercent'],
  );

  StatusTierEntity toEntity() => StatusTierEntity(
    status: status,
    minReferrals: minReferrals,
    discountPercent: discountPercent,
  );
}
