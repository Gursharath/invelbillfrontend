import 'package:flutter/material.dart';
import 'package:invenbill/models/product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/product_provider.dart';
import '../providers/stock_provider.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  int? selectedProductId;
  final _quantity = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider = context.read<ProductProvider>();
      final stockProvider = context.read<StockProvider>();

      if (productProvider.products.isEmpty) {
        await productProvider.fetchProducts(); // Make sure products are loaded
      }

      await stockProvider.fetchLogs(); // Then fetch logs
    });
  }

  void _showSnack(String message, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final stockProvider = context.watch<StockProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Management"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Select Product",
                        prefixIcon: Icon(Icons.shopping_bag),
                        border: OutlineInputBorder(),
                      ),
                      value: selectedProductId,
                      items: productProvider.products.map((p) {
                        return DropdownMenuItem(
                            value: p.id, child: Text(p.name));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedProductId = val),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantity,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        prefixIcon: Icon(Icons.confirmation_number),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_downward),
                            label: const Text("Stock In"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: selectedProductId == null
                                ? null
                                : () async {
                                    final quantity =
                                        int.tryParse(_quantity.text) ?? 0;
                                    if (quantity <= 0) {
                                      _showSnack("Enter a valid quantity",
                                          Colors.orange);
                                      return;
                                    }
                                    final success = await stockProvider.stockIn(
                                        selectedProductId!, quantity);
                                    _quantity.clear();
                                    if (success) {
                                      _showSnack(
                                          "Stock In Successful", Colors.green);
                                    } else {
                                      _showSnack("Stock In Failed", Colors.red);
                                    }
                                  },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_upward),
                            label: const Text("Stock Out"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: selectedProductId == null
                                ? null
                                : () async {
                                    final quantity =
                                        int.tryParse(_quantity.text) ?? 0;
                                    if (quantity <= 0) {
                                      _showSnack("Enter a valid quantity",
                                          Colors.orange);
                                      return;
                                    }
                                    final success = await stockProvider
                                        .stockOut(selectedProductId!, quantity);
                                    _quantity.clear();
                                    if (success) {
                                      _showSnack(
                                          "Stock Out Successful", Colors.green);
                                    } else {
                                      _showSnack(
                                          "Stock Out Failed", Colors.red);
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Stock Logs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: stockProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : stockProvider.logs.isEmpty
                      ? const Center(child: Text("No logs available"))
                      : ListView.separated(
                          itemCount: stockProvider.logs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final log = stockProvider.logs[index];
                            final product = productProvider.products.firstWhere(
                              (p) => p.id == log.productId,
                              orElse: () => Product(
                                id: log.productId,
                                name: 'Unknown Product',
                                barcode: '',
                                price: 0.0,
                                quantity: 0,
                                imagePath: null,
                              ),
                            );
                            final formattedDate =
                                DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(log.date);

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  log.action.toLowerCase() == 'in'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: log.action.toLowerCase() == 'in'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(product.name),
                                subtitle: Text(
                                    "Action: ${log.action.toUpperCase()} | Qty: ${log.quantity}"),
                                trailing: Text(
                                  formattedDate,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
