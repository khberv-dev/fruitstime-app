import 'package:fruitstime/features/auth/data/enum/tier.dart';

class StatusTierEntity {
  final Tier status;
  final int minReferrals;
  final int discountPercent;

  StatusTierEntity({
    required this.status,
    required this.minReferrals,
    required this.discountPercent,
  });
}
