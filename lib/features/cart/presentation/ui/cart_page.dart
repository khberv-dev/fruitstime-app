import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/login_screen.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/fulfillment_provider.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_branch_selector.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_delivery_selector.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_header.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/cart_items_list.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/empty_cart.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/fulfillment_toggle.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/goto_pay_button.dart';
import 'package:fruitstime/features/cart/presentation/ui/widget/summary_card.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/presentation/controller/create_order_provider.dart';
import 'package:fruitstime/features/order/presentation/controller/selected_order_provider.dart';
import 'package:fruitstime/features/order/presentation/ui/order_detail_screen.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final cart = ref.watch(cartProvider);
    final cartCount = ref.read(cartProvider.notifier).totalProductsCount();
    final cartTypesCount = ref.read(cartProvider.notifier).totalProductsTypesCount();
    final cartPrice = ref.read(cartProvider.notifier).totalProductsPrice();
    final createOrderState = ref.watch(createOrderControllerProvider);
    final fulfillment = ref.watch(fulfillmentProvider);
    final isDelivery = fulfillment.type == OrderType.delivery;

    void onAddProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).addProduct(product);
    }

    void onPopProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).popProduct(product);
    }

    void onPaymentClick() {
      if (ref.read(userProvider).data == null) {
        context.push(LoginScreen.path);
        return;
      }
      ref.read(createOrderControllerProvider.notifier).create(cart);
    }

    ref.listen(createOrderControllerProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
        ref.read(createOrderControllerProvider.notifier).reset();
      }

      if (state.data != null) {
        ref.read(selectedOrderProvider.notifier).select(state.data);
        ref.read(cartProvider.notifier).clear();
        ref.read(createOrderControllerProvider.notifier).reset();
        context.push(OrderDetailScreen.path);
      }
    });

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
                        FulfillmentToggle(),
                        SizedBox(height: AppSpacing.lg),
                        isDelivery ? CartDeliverySelector() : CartBranchSelector(),
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
                        GotoPayButton(
                          label: localization.sendOrderButton,
                          onPressed:
                              (createOrderState.isLoading ||
                                  (isDelivery && fulfillment.address == null))
                              ? null
                              : onPaymentClick,
                        ),
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
