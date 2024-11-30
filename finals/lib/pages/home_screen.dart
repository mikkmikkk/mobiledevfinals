import 'package:flutter/material.dart';
import 'products_page.dart';
import 'suppliers_page.dart';
import 'supply_orders_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Ensure the length matches the number of tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Dashboard'), // Added const for better optimization
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Suppliers'),
            Tab(text: 'Supply Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductsPage(),    // Ensure ProductsPage is defined correctly in products_page.dart
          SuppliersPage(),   // Ensure SuppliersPage is defined correctly in suppliers_page.dart
          SupplyOrdersPage() // Ensure SupplyOrdersPage is defined correctly in supply_orders_page.dart
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
}
