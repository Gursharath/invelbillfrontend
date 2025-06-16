import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final stockProvider = context.watch<StockProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Stock Management")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Select Product"),
              items: productProvider.products.map((p) {
                return DropdownMenuItem(value: p.id, child: Text(p.name));
              }).toList(),
              onChanged: (val) => setState(() => selectedProductId = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Stock In"),
                    onPressed: selectedProductId == null
                        ? null
                        : () async {
                            await stockProvider.stockIn(selectedProductId!,
                                int.tryParse(_quantity.text) ?? 0);
                          },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.remove),
                    label: const Text("Stock Out"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: selectedProductId == null
                        ? null
                        : () async {
                            await stockProvider.stockOut(selectedProductId!,
                                int.tryParse(_quantity.text) ?? 0);
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: stockProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: stockProvider.logs.map((log) {
                        return ListTile(
                          title: Text('Product ID: ${log.productId}'),
                          subtitle: Text(
                              'Action: ${log.action} | Qty: ${log.quantity}'),
                          trailing: Text('${log.date}'),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
