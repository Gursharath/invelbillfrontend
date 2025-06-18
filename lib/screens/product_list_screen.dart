import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../models/product.dart';
import 'package:pdf/widgets.dart' as pw;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = "";
  String _sortOption = 'A-Z';

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

  List<Product> _sortProducts(List<Product> products) {
    switch (_sortOption) {
      case 'Z-A':
        products.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price Low-High':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High-Low':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
    return products;
  }

  Future<void> _printProductReport(List<Product> products) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Product Report", style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Name', 'Barcode', 'Price', 'Qty'],
              data: products
                  .map((p) => [
                        p.name,
                        p.barcode,
                        p.price.toString(),
                        p.quantity.toString()
                      ])
                  .toList(),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final filteredProducts =
        _sortProducts(_filterProducts(provider.products, _searchQuery));
    final totalValue =
        filteredProducts.fold(0.0, (sum, p) => sum + (p.price * p.quantity));
    final lowStockCount =
        filteredProducts.where((p) => p.quantity < 5 && p.quantity > 0).length;
    final outOfStockCount =
        filteredProducts.where((p) => p.quantity == 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export as PDF',
            onPressed: () {
              _printProductReport(filteredProducts);
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await context.read<ProductProvider>().fetchProducts();
              },
              child: Column(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatBox("${filteredProducts.length}", "Products",
                            Colors.blue),
                        _buildStatBox("₹${totalValue.toStringAsFixed(2)}",
                            "Inventory", Colors.green),
                        _buildStatBox(
                            "$lowStockCount", "Low Stock", Colors.orange),
                        _buildStatBox(
                            "$outOfStockCount", "Out of Stock", Colors.red),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: _sortOption,
                          items: [
                            'A-Z',
                            'Z-A',
                            'Price Low-High',
                            'Price High-Low'
                          ]
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortOption = value;
                              });
                            }
                          },
                        ),
                      ],
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final product = filteredProducts[i];
                            final stockColor = product.quantity == 0
                                ? Colors.red
                                : product.quantity < 5
                                    ? Colors.orange
                                    : Colors.green;
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: ProductTile(product: product)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: stockColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        product.quantity == 0
                                            ? "Out of Stock"
                                            : product.quantity < 5
                                                ? "Low Stock"
                                                : "In Stock",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
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

  Widget _buildStatBox(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}
