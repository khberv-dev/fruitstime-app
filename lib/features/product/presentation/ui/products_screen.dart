import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/controller/bottom_navbar_provider.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/features/catalog/presentation/controller/selected_catalog_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/controller/products_provider.dart';
import 'package:fruitstime/features/product/presentation/ui/product_view_sheet.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/goto_cart_button.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/product_list.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/products_header.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  static const path = '/products';

  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  double cartInfoY = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).getByCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(selectedCatalogProvider)!;
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);
    final cartCount = ref.read(cartProvider.notifier).totalProductsCount();
    final cartPrice = ref.read(cartProvider.notifier).totalProductsPrice();

    void onAddProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).addProduct(product);
    }

    void onPopProductCartClick(ProductEntity product) {
      ref.read(cartProvider.notifier).popProduct(product);
    }

    void onBackClick() {
      context.pop();
    }

    void onGotoCartClick() {
      context.pop();
      ref.read(bottomNavbarProvider.notifier).state = 2;
    }

    void onProductItemClick(ProductEntity product) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ProductViewSheet(product: product),
      );
    }

    setState(() {
      cartInfoY = cartCount > 0 ? 0 : 128;
    });

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  ProductsHeader(catalogTitle: catalog.title, onBackClick: onBackClick),
                  SizedBox(height: AppSpacing.md),
                  products.data == null || products.isLoading
                      ? CircularProgressIndicator()
                      : Expanded(
                          child: ProductList(
                            products: products.data!,
                            cartData: cart,
                            onItemClick: onProductItemClick,
                            onAddCartClick: onAddProductCartClick,
                            onPopCartClick: onPopProductCartClick,
                          ),
                        ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                transform: Matrix4.translationValues(0, cartInfoY, 0),
                height: 128,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                child: Column(
                  children: [
                    Divider(height: 0),
                    SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$cartCount ta mahsulot",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                "${formatNumber(cartPrice)} so'm",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          GotoCartButton(onPressed: onGotoCartClick),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
