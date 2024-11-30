import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supply_order.dart';

final supplyOrderListProvider =
    StateNotifierProvider<SupplyOrderNotifier, List<SupplyOrder>>(
  (ref) => SupplyOrderNotifier(),
);

class SupplyOrderNotifier extends StateNotifier<List<SupplyOrder>> {
  SupplyOrderNotifier() : super([]);

  void addSupplyOrder(SupplyOrder order) {
    state = [...state, order];
  }
}
