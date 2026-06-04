import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/assistant/presentation/ui/widget/message_suggested_product_item.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class ChatMessage extends ConsumerWidget {
  final MessageEntity message;
  final Function(ProductEntity) onProductItemClick;

  const ChatMessage({super.key, required this.message, required this.onProductItemClick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageId = ref.watch(selectedBranchProvider)?.storageId;

    final sentMessageDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.all(
        Radius.circular(AppRadius.md),
      ).copyWith(bottomRight: Radius.circular(4)),
    );

    final receivedMessageDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(30)),
      borderRadius: BorderRadius.all(
        Radius.circular(AppRadius.md),
      ).copyWith(bottomLeft: Radius.circular(4)),
    );

    return Row(
      mainAxisAlignment: message.from == MessageSender.me
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          constraints: BoxConstraints(
            minWidth: 128,
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: message.from == MessageSender.me
              ? sentMessageDecoration
              : receivedMessageDecoration,
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.text),
              SizedBox(height: AppSpacing.sm),
              if (message.suggestedProducts.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(message.suggestedProducts.length, (index) {
                      final product = message.suggestedProducts[index];
                      final isAvailable = product.isAvailableAt(storageId);
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: isAvailable ? () => onProductItemClick(product) : null,
                            child: MessageSuggestedProductItem(
                              product: product,
                              isAvailable: isAvailable,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                        ],
                      );
                    }),
                  ),
                )
              else
                SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
