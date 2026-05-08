import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final cartProvider = NotifierProvider(_CartNotifier.new);

class _CartNotifier extends Notifier<Map<ProductEntity, int>> {
  @override
  Map<ProductEntity, int> build() => {};

  ProductEntity _getKeyProduct(ProductEntity product) {
    return state.keys.where((key) => key.id == product.id).firstOrNull ?? product;
  }

  void addProduct(ProductEntity product) {
    final keyProduct = _getKeyProduct(product);
    final int count = (state[keyProduct] ?? 0) + 1;

    state = {...state, keyProduct: count};
  }

  void popProduct(ProductEntity product) {
    final keyProduct = _getKeyProduct(product);
    final int count = (state[keyProduct] ?? 0) - 1;

    if (count > 0) {
      state = {...state, keyProduct: count};
    } else {
      final Map<ProductEntity, int> newState = Map.from(state);

      newState.remove(keyProduct);
      state = newState;
    }
  }

  int totalProductsCount() {
    int count = 0;

    for (var value in state.values) {
      count += value;
    }

    return count;
  }

  int totalProductsTypesCount() {
    return state.keys.length;
  }

  int totalProductsPrice() {
    int price = 0;

    for (var entry in state.entries) {
      price += entry.key.price * entry.value;
    }

    return price;
  }

  void clear() {
    state = {};
  }
}
