import 'package:flutter/material.dart';
import 'package:invenbill/models/product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider = context.read<ProductProvider>();
      final stockProvider = context.read<StockProvider>();

      if (productProvider.products.isEmpty) {
        await productProvider.fetchProducts();
      }

      await stockProvider.fetchLogs();
    });
  }

  void _showSnack(String message, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.orbitron()),
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
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          "Stock Management",
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.tealAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A2A2A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF2C2C2E),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      dropdownColor: const Color(0xFF2C2C2E),
                      decoration: InputDecoration(
                        labelText: "Select Product",
                        labelStyle: GoogleFonts.orbitron(color: Colors.white),
                        prefixIcon: const Icon(Icons.shopping_bag),
                        border: const OutlineInputBorder(),
                      ),
                      value: selectedProductId,
                      items: productProvider.products.map((p) {
                        return DropdownMenuItem(
                          value: p.id,
                          child: Text(
                            p.name,
                            style: GoogleFonts.orbitron(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedProductId = val),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantity,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.orbitron(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Quantity",
                        labelStyle: GoogleFonts.orbitron(color: Colors.white),
                        prefixIcon: const Icon(Icons.confirmation_number),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_downward),
                            label: Text(
                              "Stock In",
                              style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                            label: Text(
                              "Stock Out",
                              style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Stock Logs",
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: stockProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : stockProvider.logs.isEmpty
                      ? Center(
                          child: Text(
                            "No logs available",
                            style: GoogleFonts.orbitron(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        )
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
                              color: const Color(0xFF2C2C2E),
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
                                title: Text(
                                  product.name,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  "Action: ${log.action.toUpperCase()} | Qty: ${log.quantity}",
                                  style: GoogleFonts.orbitron(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                trailing: Text(
                                  formattedDate,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 11,
                                    color: Colors.white60,
                                  ),
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
