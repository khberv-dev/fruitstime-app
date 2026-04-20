import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/product/data/dto/product_dto.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class MessageDto {
  final String text;
  final MessageSender from;
  final List<ProductEntity> suggestedProducts;

  MessageDto({required this.text, required this.from, required this.suggestedProducts});

  factory MessageDto.parse(Map<String, dynamic> data) {
    final suggestedProductsData = List<Map<String, dynamic>>.from(data['suggestions']);

    final products = suggestedProductsData
        .map((element) => ProductDto.parse(element).toEntity())
        .toList();

    return MessageDto(
      text: data['text'],
      from: data['from'] == 'me' ? MessageSender.me : MessageSender.ai,
      suggestedProducts: products,
    );
  }

  MessageEntity toEntity() =>
      MessageEntity(text: text, from: from, suggestedProducts: suggestedProducts);
}
