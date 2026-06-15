import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class MessageEntity {
  final String text;
  final MessageSender from;
  final List<ProductEntity> suggestedProducts;
  final List<String> cartProductIds;
  final DateTime createdAt;

  MessageEntity({
    required this.text,
    required this.from,
    required this.suggestedProducts,
    this.cartProductIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
