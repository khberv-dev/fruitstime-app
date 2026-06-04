import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class MessageEntity {
  final String text;
  final MessageSender from;
  final List<ProductEntity> suggestedProducts;
  final DateTime createdAt;

  MessageEntity({
    required this.text,
    required this.from,
    required this.suggestedProducts,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
