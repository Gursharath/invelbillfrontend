import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../providers/product_provider.dart';
import '../providers/invoice_provider.dart';
import '../models/product.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});
  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _customerName = TextEditingController();
  final Map<Product, int> _selectedProducts = {};
  double subtotal = 0, tax = 0, total = 0;

  void calculateTotals() {
    subtotal = 0;
    for (var entry in _selectedProducts.entries) {
      subtotal += entry.key.price * entry.value;
    }
    tax = subtotal * 0.18;
    total = subtotal + tax;
  }

  Future<void> printInvoice(
      String customerName, Map<Product, int> selectedProducts) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("INVOICE",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              if (customerName.isNotEmpty)
                pw.Text("Customer: $customerName",
                    style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Product', 'Qty', 'Price', 'Total'],
                data: selectedProducts.entries.map((e) {
                  final product = e.key;
                  final qty = e.value;
                  final price = product.price;
                  return [
                    product.name,
                    qty.toString(),
                    '${price.toStringAsFixed(2)}',
                    '${(price * qty).toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Subtotal: ${subtotal.toStringAsFixed(2)}"),
                    pw.Text("Tax (18%): ${tax.toStringAsFixed(2)}"),
                    pw.Text("Total: ${total.toStringAsFixed(2)}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final invoiceProvider = context.watch<InvoiceProvider>();

    calculateTotals();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Invoice")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  TextField(
                    controller: _customerName,
                    decoration: InputDecoration(
                      labelText: "Customer Name (optional)",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Products",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...productProvider.products.map((product) {
                    final quantity = _selectedProducts[product] ?? 0;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(product.name),
                                subtitle: Text(
                                    "₹${product.price.toStringAsFixed(2)}"),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                initialValue:
                                    quantity == 0 ? '' : quantity.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Qty",
                                ),
                                onChanged: (val) {
                                  final qty = int.tryParse(val) ?? 0;
                                  setState(() {
                                    if (qty > 0) {
                                      _selectedProducts[product] = qty;
                                    } else {
                                      _selectedProducts.remove(product);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Card(
                    color: const Color.fromARGB(255, 22, 22, 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Subtotal: ₹${subtotal.toStringAsFixed(2)}"),
                          Text("Tax (18%): ₹${tax.toStringAsFixed(2)}"),
                          const SizedBox(height: 6),
                          Text("Total: ₹${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _selectedProducts.isEmpty
                        ? null
                        : () async {
                            final items = _selectedProducts.entries
                                .map((e) => {
                                      'product_id': e.key.id,
                                      'quantity': e.value
                                    })
                                .toList();

                            final ok = await invoiceProvider.createInvoice(
                              _customerName.text,
                              items,
                            );

                            if (ok) {
                              await printInvoice(
                                  _customerName.text, _selectedProducts);
                            }
                          },
                    label: const Text("Generate & Print Invoice",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
      ),
    );
  }
}
