import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchProducts();
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;

    return products.where((product) {
      final nameMatch =
          product.name.toLowerCase().contains(query.toLowerCase());
      final barcodeMatch =
          product.barcode.toLowerCase().contains(query.toLowerCase());
      return nameMatch || barcodeMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final filteredProducts = _filterProducts(provider.products, _searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductProvider>().fetchProducts();
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by name or barcode...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (filteredProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text("No matching products found."),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.separated(
                        itemCount: filteredProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final product = filteredProducts[i];
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: ProductTile(product: product),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
