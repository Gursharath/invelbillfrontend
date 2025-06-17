import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ScanProductDetailScreen extends StatefulWidget {
  const ScanProductDetailScreen({super.key});

  @override
  State<ScanProductDetailScreen> createState() =>
      _ScanProductDetailScreenState();
}

class _ScanProductDetailScreenState extends State<ScanProductDetailScreen> {
  Product? _scannedProduct;
  bool _isLoading = false;

  void _handleScanResult(String barcode) {
    final productProvider = context.read<ProductProvider>();
    final product = productProvider.products.firstWhere(
      (p) => p.barcode == barcode,
      orElse: () =>
          Product(id: -1, name: '', barcode: '', price: 0, quantity: 0),
    );

    if (product.id == -1) {
      Navigator.pushNamed(context, '/add-product', arguments: barcode);
    } else {
      setState(() {
        _scannedProduct = product;
      });
    }
  }

  Future<void> _startScan() async {
    final result = await Navigator.pushNamed(context, '/scan-product');
    if (result is String) {
      _handleScanResult(result);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Product Detail"),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scannedProduct == null
              ? Center(
                  child: Text(
                    "No product scanned yet.",
                    style: textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onBackground),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: theme.colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(Icons.qr_code_scanner,
                                size: 50, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(height: 24),
                          _buildDetailRow(
                            icon: Icons.shopping_bag,
                            label: "Name",
                            value: _scannedProduct!.name,
                            theme: theme,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            icon: Icons.qr_code,
                            label: "Barcode",
                            value: _scannedProduct!.barcode,
                            theme: theme,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            icon: Icons.currency_rupee,
                            label: "Price",
                            value: "₹${_scannedProduct!.price}",
                            theme: theme,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            icon: Icons.inventory,
                            label: "Available Quantity",
                            value: "${_scannedProduct!.quantity} units",
                            theme: theme,
                          ),
                          const Spacer(),
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: const Text("Done"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, color: theme.colorScheme.onSurface)),
            ],
          ),
        ),
      ],
    );
  }
}
