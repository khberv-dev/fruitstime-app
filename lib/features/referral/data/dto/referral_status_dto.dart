import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/features/referral/domain/entity/referral_status_entity.dart';

class ReferralStatusDto {
  final String code;
  final int count;
  final Tier status;
  final int discountPercent;
  final Tier? nextStatus;
  final int? nextDiscountPercent;
  final int remaining;

  ReferralStatusDto({
    required this.code,
    required this.count,
    required this.status,
    required this.discountPercent,
    this.nextStatus,
    this.nextDiscountPercent,
    required this.remaining,
  });

  factory ReferralStatusDto.parse(Map<String, dynamic> data) => ReferralStatusDto(
    code: data['code'],
    count: data['count'],
    status: Tier.values.byName(data['status']),
    discountPercent: data['discountPercent'],
    nextStatus: data['nextStatus'] != null ? Tier.values.byName(data['nextStatus']) : null,
    nextDiscountPercent: data['nextDiscountPercent'],
    remaining: data['remaining'],
  );

  ReferralStatusEntity toEntity() => ReferralStatusEntity(
    code: code,
    count: count,
    status: status,
    discountPercent: discountPercent,
    nextStatus: nextStatus,
    nextDiscountPercent: nextDiscountPercent,
    remaining: remaining,
  );
}
