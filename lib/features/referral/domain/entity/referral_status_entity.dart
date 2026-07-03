import 'package:fruitstime/features/auth/data/enum/tier.dart';

class ReferralStatusEntity {
  final String code;
  final int count;
  final Tier status;
  final int discountPercent;
  final Tier? nextStatus;
  final int? nextDiscountPercent;
  final int remaining;

  ReferralStatusEntity({
    required this.code,
    required this.count,
    required this.status,
    required this.discountPercent,
    this.nextStatus,
    this.nextDiscountPercent,
    required this.remaining,
  });
}
