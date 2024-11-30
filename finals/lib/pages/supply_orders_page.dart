import 'package:flutter/material.dart';

class SupplyOrdersPage extends StatefulWidget {
  @override
  _SupplyOrdersPageState createState() => _SupplyOrdersPageState();
}

class _SupplyOrdersPageState extends State<SupplyOrdersPage> {
  List<Map<String, dynamic>> allOrders = [
    {'id': 1, 'supplier': 'Supplier A', 'product': 'Product A', 'quantity': 100, 'status': 'Delivered'},
    {'id': 2, 'supplier': 'Supplier B', 'product': 'Product B', 'quantity': 50, 'status': 'Pending'},
    {'id': 3, 'supplier': 'Supplier C', 'product': 'Product C', 'quantity': 75, 'status': 'Shipped'},
  ];

  List<Map<String, dynamic>> displayedOrders = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedOrders = allOrders;
    searchController.addListener(_filterOrders);
  }

  void _filterOrders() {
    final query = searchController.text.toLowerCase();
    setState(() {
      displayedOrders = allOrders.where((order) {
        return order['supplier'].toLowerCase().contains(query) ||
            order['product'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addOrder() {
    final supplier = supplierController.text;
    final product = productController.text;
    final quantity = int.tryParse(quantityController.text);
    final status = statusController.text;

    if (supplier.isNotEmpty && product.isNotEmpty && quantity != null && status.isNotEmpty) {
      setState(() {
        allOrders.add({
          'id': allOrders.length + 1,
          'supplier': supplier,
          'product': product,
          'quantity': quantity,
          'status': status,
        });
        displayedOrders = allOrders;
      });

      supplierController.clear();
      productController.clear();
      quantityController.clear();
      statusController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    supplierController.dispose();
    productController.dispose();
    quantityController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SupplyOrderSearchDelegate(allOrders),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Orders',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayedOrders.length,
                itemBuilder: (context, index) {
                  final order = displayedOrders[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(order['product']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Supplier: ${order['supplier']}'),
                          Text('Quantity: ${order['quantity']}'),
                          Text('Status: ${order['status']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add New Order'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: supplierController,
                            decoration: InputDecoration(labelText: 'Supplier'),
                          ),
                          TextField(
                            controller: productController,
                            decoration: InputDecoration(labelText: 'Product'),
                          ),
                          TextField(
                            controller: quantityController,
                            decoration: InputDecoration(labelText: 'Quantity'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: statusController,
                            decoration: InputDecoration(labelText: 'Status'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _addOrder,
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Order'),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplyOrderSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allOrders;

  SupplyOrderSearchDelegate(this.allOrders);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allOrders.where((order) {
      return order['supplier'].toLowerCase().contains(query.toLowerCase()) ||
          order['product'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final order = results[index];
        return ListTile(
          title: Text(order['product']),
          subtitle: Text('Supplier: ${order['supplier']} | Status: ${order['status']}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allOrders.where((order) {
      return order['supplier'].toLowerCase().contains(query.toLowerCase()) ||
          order['product'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final order = suggestions[index];
        return ListTile(
          title: Text(order['product']),
          subtitle: Text('Supplier: ${order['supplier']} | Status: ${order['status']}'),
        );
      },
    );
  }
}
