class LoyaltyStatusEntity {
  final bool isActive;
  final int itemsOrdered;
  final int itemsUntilNextFree;

  LoyaltyStatusEntity({
    required this.isActive,
    required this.itemsOrdered,
    required this.itemsUntilNextFree,
  });
}
