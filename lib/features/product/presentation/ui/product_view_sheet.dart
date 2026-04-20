import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/item_counter.dart';
import 'package:fruitstime/core/ui/widget/label_badge.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/add_cart_button.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:go_router/go_router.dart';

class _SummaryItemsPrice extends StatelessWidget {
  final int value;

  const _SummaryItemsPrice({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Column(
        children: [
          Text(
            localization.totalLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          Text(
            "${formatNumber(value)} so'm",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductViewSheet extends ConsumerWidget {
  final ProductEntity product;

  const ProductViewSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final itemsCount = cart[product] ?? 0;
    final itemsPrice = itemsCount * product.price;
    final localization = AppLocalizations.of(context)!;

    void onCloseClick() {
      context.pop();
    }

    void onAddProductCartClick() {
      ref.read(cartProvider.notifier).addProduct(product);
    }

    void onPopProductCartClick() {
      ref.read(cartProvider.notifier).popProduct(product);
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
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
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: IconButton(
                    onPressed: onCloseClick,
                    icon: SvgPicture.asset('assets/icons/close.svg'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                "${formatNumber(product.price)} so'm",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    localization.ingredientsLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: List.generate(
                      product.compound.length,
                      (index) => LabelBadge(
                        text: product.compound[index],
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemsCount > 0
                  ? ItemCounter(
                      value: itemsCount,
                      onIncrementClick: onAddProductCartClick,
                      onDecrementClick: onPopProductCartClick,
                    )
                  : SizedBox(),
              SizedBox(
                width: 128,
                child: itemsCount > 0
                    ? _SummaryItemsPrice(value: itemsPrice)
                    : AddCartButton(onPressed: onAddProductCartClick),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
