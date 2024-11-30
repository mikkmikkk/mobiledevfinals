import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Initial product data
  List<Map<String, dynamic>> allProducts = [
    {'id': 1, 'name': 'Product A', 'price': 19.99, 'stock': 100},
    {'id': 2, 'name': 'Product B', 'price': 29.99, 'stock': 50},
    {'id': 3, 'name': 'Product C', 'price': 39.99, 'stock': 75},
  ];

  // Variable to store the filtered list
  List<Map<String, dynamic>> displayedProducts = [];

  // Text controllers for adding products
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedProducts = allProducts;
    searchController.addListener(_filterProducts); // Listen for changes in the search bar
  }

  // Filter the products based on the search query
  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      displayedProducts = allProducts.where((product) {
        return product['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  // Add a new product to the list
  void _addProduct() {
    final name = nameController.text;
    final price = double.tryParse(priceController.text);
    final stock = int.tryParse(stockController.text);

    if (name.isNotEmpty && price != null && stock != null) {
      setState(() {
        allProducts.add({
          'id': allProducts.length + 1,
          'name': name,
          'price': price,
          'stock': stock,
        });
        displayedProducts = allProducts; // Update displayed list after adding
      });

      // Clear the text fields and close the dialog
      nameController.clear();
      priceController.clear();
      stockController.clear();
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          // Search button in the AppBar
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show the search bar
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(allProducts),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar at the top of the page
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              // List of products that match the search
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \$${product['price']}'),
                          Text('Stock: ${product['stock']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Button to show the dialog to add a new product
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add New Product'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Product Name'),
                          ),
                          TextField(
                            controller: priceController,
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: stockController,
                            decoration: InputDecoration(labelText: 'Stock'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _addProduct,
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Delegate for Product search
class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allProducts;

  ProductSearchDelegate(this.allProducts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product['name']),
          subtitle: Text('Price: \$${product['price']} | Stock: ${product['stock']}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allProducts.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product['name']),
          subtitle: Text('Price: \$${product['price']} | Stock: ${product['stock']}'),
        );
      },
    );
  }
}
