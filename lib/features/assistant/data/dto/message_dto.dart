import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/product/data/dto/product_dto.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class MessageDto {
  final String text;
  final MessageSender from;
  final List<ProductEntity> suggestedProducts;
  final List<String> cartProductIds;
  final DateTime createdAt;

  MessageDto({
    required this.text,
    required this.from,
    required this.suggestedProducts,
    this.cartProductIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MessageDto.parse(Map<String, dynamic> data) {
    final suggestedProductsData = List<Map<String, dynamic>>.from(data['suggestions']);

    final products = suggestedProductsData
        .map((element) => ProductDto.parse(element).toEntity())
        .toList();

    final cart = data['cart'];
    final cartIds = cart is List ? List<String>.from(cart) : <String>[];

    return MessageDto(
      text: data['text'],
      from: data['from'] == 'me' ? MessageSender.me : MessageSender.ai,
      suggestedProducts: products,
      cartProductIds: cartIds,
    );
  }

  factory MessageDto.parseHistoryItem(Map<String, dynamic> data) {
    final raw = data['suggestions'];
    final products = raw is List
        ? raw.map((e) => ProductDto.parse(e as Map<String, dynamic>).toEntity()).toList()
        : <ProductEntity>[];

    return MessageDto(
      text: data['text'] as String,
      from: data['role'] == 'user' ? MessageSender.me : MessageSender.ai,
      suggestedProducts: products,
      // history messages must not re-trigger cart adds
      cartProductIds: const [],
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  MessageEntity toEntity() => MessageEntity(
    text: text,
    from: from,
    suggestedProducts: suggestedProducts,
    cartProductIds: cartProductIds,
    createdAt: createdAt,
  );
}
