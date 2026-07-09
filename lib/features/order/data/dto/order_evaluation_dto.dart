import 'package:fruitstime/features/order/domain/entity/order_evaluation_entity.dart';

class OrderDiscountDto {
  final String name;
  final int amount;

  OrderDiscountDto({required this.name, required this.amount});

  factory OrderDiscountDto.parse(Map<String, dynamic> data) =>
      OrderDiscountDto(name: data['name'], amount: data['amount']);

  OrderDiscountEntity toEntity() => OrderDiscountEntity(name: name, amount: amount);
}

class OrderEvaluationItemDto {
  final String productId;
  final String title;
  final int quantity;
  final int unitPrice;
  final int lineTotal;
  final int price;

  OrderEvaluationItemDto({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.price,
  });

  factory OrderEvaluationItemDto.parse(Map<String, dynamic> data) => OrderEvaluationItemDto(
    productId: data['productId'],
    title: data['title'],
    quantity: data['quantity'],
    unitPrice: data['unitPrice'],
    lineTotal: data['lineTotal'],
    price: data['price'],
  );

  OrderEvaluationItemEntity toEntity() => OrderEvaluationItemEntity(
    productId: productId,
    title: title,
    quantity: quantity,
    unitPrice: unitPrice,
    lineTotal: lineTotal,
    price: price,
  );
}

class OrderEvaluationDto {
  final List<OrderEvaluationItemDto> items;
  final int productsCount;
  final int productTypesCount;
  final int subtotal;
  final List<OrderDiscountDto> discounts;
  final int discountTotal;
  final int? deliveryCost;
  final int total;

  OrderEvaluationDto({
    required this.items,
    required this.productsCount,
    required this.productTypesCount,
    required this.subtotal,
    required this.discounts,
    required this.discountTotal,
    this.deliveryCost,
    required this.total,
  });

  factory OrderEvaluationDto.parse(Map<String, dynamic> data) => OrderEvaluationDto(
    items: (data['items'] as List<dynamic>)
        .map((e) => OrderEvaluationItemDto.parse(e as Map<String, dynamic>))
        .toList(),
    productsCount: data['productsCount'],
    productTypesCount: data['productTypesCount'],
    subtotal: data['subtotal'],
    discounts: (data['discounts'] as List<dynamic>)
        .map((e) => OrderDiscountDto.parse(e as Map<String, dynamic>))
        .toList(),
    discountTotal: data['discountTotal'],
    deliveryCost: data['deliveryCost'],
    total: data['total'],
  );

  OrderEvaluationEntity toEntity() => OrderEvaluationEntity(
    items: items.map((e) => e.toEntity()).toList(),
    productsCount: productsCount,
    productTypesCount: productTypesCount,
    subtotal: subtotal,
    discounts: discounts.map((e) => e.toEntity()).toList(),
    discountTotal: discountTotal,
    deliveryCost: deliveryCost,
    total: total,
  );
}
