import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/features/cart/presentation/ui/payment_sheet.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_header.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_items_list.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/empty_cart.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/goto_pay_button.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/summary_card.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final cart = ref.watch(cartProvider);
    final cartCount = ref.read(cartProvider.notifier).totalProductsCount();
    final cartTypesCount = ref.read(cartProvider.notifier).totalProductsTypesCount();
    final cartPrice = ref.read(cartProvider.notifier).totalProductsPrice();

    void onAddProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).addProduct(product);
    }

    void onPopProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).popProduct(product);
    }

    void onPaymentClick() {
      showModalBottomSheet(context: context, builder: (_) => PaymentSheet());
    }

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          CartHeader(),
          Expanded(
            child: cartTypesCount > 0
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 96),
                    child: Column(
                      children: [
                        CartItemsList(
                          cartData: cart,
                          onAddCartClick: onAddProductCartClick,
                          onPopCartClick: onPopProductCartClick,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        TextField(
                          decoration: InputDecoration(labelText: localization.orderNoteHint),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        SummaryCard(
                          totalItemCount: cartCount,
                          totalItemTypeCount: cartTypesCount,
                          totalCartPrice: cartPrice,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        GotoPayButton(onPressed: onPaymentClick),
                      ],
                    ),
                  )
                : Center(child: EmptyCart()),
          ),
        ],
      ),
    );
  }
}
