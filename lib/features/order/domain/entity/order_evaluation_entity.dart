class OrderDiscountEntity {
  final String name;
  final int amount;

  OrderDiscountEntity({required this.name, required this.amount});
}

class OrderEvaluationItemEntity {
  final String productId;
  final String title;
  final int quantity;
  final int unitPrice;
  final int lineTotal;
  final int price;

  OrderEvaluationItemEntity({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.price,
  });
}

class OrderEvaluationEntity {
  final List<OrderEvaluationItemEntity> items;
  final int subtotal;
  final List<OrderDiscountEntity> discounts;
  final int discountTotal;
  final int? deliveryCost;
  final int total;

  OrderEvaluationEntity({
    required this.items,
    required this.subtotal,
    required this.discounts,
    required this.discountTotal,
    this.deliveryCost,
    required this.total,
  });
}
