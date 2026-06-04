import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/widget/product_list_item.dart';

class ProductList extends ConsumerWidget {
  final List<ProductEntity> products;
  final Map<ProductEntity, int> cartData;
  final Function(ProductEntity) onItemClick;
  final Function(ProductEntity) onAddCartClick;
  final Function(ProductEntity) onPopCartClick;

  const ProductList({
    super.key,
    required this.products,
    required this.cartData,
    required this.onItemClick,
    required this.onAddCartClick,
    required this.onPopCartClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBranches = ref.watch(branchesProvider).data ?? [];
    final selectedBranch = ref.watch(selectedBranchProvider);
    final storageId = selectedBranch?.storageId;

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 128),
      itemBuilder: (_, index) {
        final product = products[index];
        final isAvailable = product.isAvailableAt(storageId);

        String? availableAt;
        if (!isAvailable) {
          final names = allBranches
              .where((b) => b != selectedBranch && product.isAvailableAt(b.storageId))
              .map((b) => b.name)
              .toList();
          if (names.isNotEmpty) availableAt = names.join(', ');
        }

        return ProductListItem(
          product: product,
          countInCart: cartData[product] ?? 0,
          onPressed: onItemClick,
          onAddCartClick: () => onAddCartClick(product),
          onPopCartClick: () => onPopCartClick(product),
          isAvailable: isAvailable,
          availableAt: availableAt,
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemCount: products.length,
    );
  }
}
