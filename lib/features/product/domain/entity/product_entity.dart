import 'package:fruitstime/features/product/data/enum/product_type.dart';
import 'package:fruitstime/features/product/domain/entity/product_promotion_entity.dart';

const buyTwoGetOneFreePromotionType = 'buy_two_get_one_free';

class ProductAvailability {
  final int storageId;
  final bool left;

  const ProductAvailability({required this.storageId, required this.left});
}

class ProductEntity {
  final String id;
  final int? posId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> compound;
  final int price;
  final ProductType type;
  final List<ProductAvailability> available;
  final List<ProductPromotionEntity> promotions;

  ProductEntity({
    required this.id,
    this.posId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.compound,
    required this.price,
    required this.type,
    this.available = const [],
    this.promotions = const [],
  });

  /// Returns true when the product is in stock at the given storage.
  /// If [storageId] is null (branch has no storage configured) or the product
  /// has no availability data yet, it is treated as available.
  bool isAvailableAt(int? storageId) {
    if (storageId == null || available.isEmpty) return true;
    final entry = available.where((a) => a.storageId == storageId).firstOrNull;
    return entry?.left ?? true;
  }

  bool get hasBuyTwoGetOneFreePromotion =>
      promotions.any((p) => p.type == buyTwoGetOneFreePromotionType);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
