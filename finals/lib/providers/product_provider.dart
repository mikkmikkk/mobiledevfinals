import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }
}

final productListProvider =
    StateNotifierProvider<ProductNotifier, List<Product>>((ref) => ProductNotifier());
