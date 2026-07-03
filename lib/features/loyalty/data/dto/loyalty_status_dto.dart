import 'package:fruitstime/features/loyalty/domain/entity/loyalty_status_entity.dart';

class LoyaltyStatusDto {
  final bool isActive;
  final int itemsOrdered;
  final int itemsUntilNextFree;

  LoyaltyStatusDto({
    required this.isActive,
    required this.itemsOrdered,
    required this.itemsUntilNextFree,
  });

  factory LoyaltyStatusDto.parse(Map<String, dynamic> data) => LoyaltyStatusDto(
    isActive: data['isActive'],
    itemsOrdered: data['itemsOrdered'],
    itemsUntilNextFree: data['itemsUntilNextFree'],
  );

  LoyaltyStatusEntity toEntity() => LoyaltyStatusEntity(
    isActive: isActive,
    itemsOrdered: itemsOrdered,
    itemsUntilNextFree: itemsUntilNextFree,
  );
}
