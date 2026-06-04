import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class MessageSuggestedProductItem extends StatelessWidget {
  final ProductEntity product;
  final bool isAvailable;

  const MessageSuggestedProductItem({super.key, required this.product, this.isAvailable = true});

  @override
  Widget build(BuildContext context) {
    const grayscale = ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);

    Widget card = Container(
      width: 96,
      height: 96,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
              child: Text(
                product.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    if (!isAvailable) {
      card = ColorFiltered(colorFilter: grayscale, child: card);
    }

    return card;
  }
}
