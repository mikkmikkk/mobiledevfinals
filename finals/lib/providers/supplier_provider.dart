import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supplier.dart';

class SupplierNotifier extends StateNotifier<List<Supplier>> {
  SupplierNotifier() : super([]);

  void addSupplier(Supplier supplier) {
    state = [...state, supplier];
  }
}

final supplierListProvider =
    StateNotifierProvider<SupplierNotifier, List<Supplier>>((ref) => SupplierNotifier());
