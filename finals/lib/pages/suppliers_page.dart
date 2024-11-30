import 'package:flutter/material.dart';

class SuppliersPage extends StatefulWidget {
  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  List<Map<String, dynamic>> allSuppliers = [
    {'id': 1, 'name': 'Supplier A', 'contact': '123-456-789', 'email': 'a@supplier.com'},
    {'id': 2, 'name': 'Supplier B', 'contact': '234-567-890', 'email': 'b@supplier.com'},
    {'id': 3, 'name': 'Supplier C', 'contact': '345-678-901', 'email': 'c@supplier.com'},
  ];

  List<Map<String, dynamic>> displayedSuppliers = [];
  
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedSuppliers = allSuppliers;
    searchController.addListener(_filterSuppliers);
  }

  void _filterSuppliers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      displayedSuppliers = allSuppliers.where((supplier) {
        return supplier['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addSupplier() {
    final name = nameController.text;
    final contact = contactController.text;
    final email = emailController.text;

    if (name.isNotEmpty && contact.isNotEmpty && email.isNotEmpty) {
      setState(() {
        allSuppliers.add({
          'id': allSuppliers.length + 1,
          'name': name,
          'contact': contact,
          'email': email,
        });
        displayedSuppliers = allSuppliers;
      });

      nameController.clear();
      contactController.clear();
      emailController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SupplierSearchDelegate(allSuppliers),
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
                labelText: 'Search Suppliers',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayedSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = displayedSuppliers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(supplier['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact: ${supplier['contact']}'),
                          Text('Email: ${supplier['email']}'),
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
                      title: Text('Add New Supplier'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Supplier Name'),
                          ),
                          TextField(
                            controller: contactController,
                            decoration: InputDecoration(labelText: 'Contact'),
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
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
                          onPressed: _addSupplier,
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Supplier'),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplierSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allSuppliers;

  SupplierSearchDelegate(this.allSuppliers);

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
    final results = allSuppliers.where((supplier) {
      return supplier['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final supplier = results[index];
        return ListTile(
          title: Text(supplier['name']),
          subtitle: Text('Contact: ${supplier['contact']} | Email: ${supplier['email']}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allSuppliers.where((supplier) {
      return supplier['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final supplier = suggestions[index];
        return ListTile(
          title: Text(supplier['name']),
          subtitle: Text('Contact: ${supplier['contact']} | Email: ${supplier['email']}'),
        );
      },
    );
  }
}
