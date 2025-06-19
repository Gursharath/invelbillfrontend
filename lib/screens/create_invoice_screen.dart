import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text("Create Invoice",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.tealAccent,
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.qr_code_scanner),
        label: Text("Scan", style: GoogleFonts.orbitron()),
        onPressed: () async {
          final barcode = await Navigator.pushNamed(context, '/scan-product');
          if (barcode is String) {
            final product = productProvider.products.firstWhere(
              (p) => p.barcode == barcode,
              orElse: () => Product(
                id: -1,
                name: '',
                barcode: '',
                price: 0,
                quantity: 0,
              ),
            );

            if (product.id != -1) {
              setState(() {
                _selectedProducts.update(product, (qty) => qty + 1,
                    ifAbsent: () => 1);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Product not found", style: GoogleFonts.orbitron()),
                ),
              );
            }
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  TextField(
                    controller: _customerName,
                    style: GoogleFonts.orbitron(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Customer Name (optional)",
                      labelStyle: GoogleFonts.orbitron(),
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Select Products",
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  ...productProvider.products.map((product) {
                    final quantity = _selectedProducts[product] ?? 0;

                    return Card(
                      color: const Color(0xFF2C2C2E),
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
                                title: Text(product.name,
                                    style: GoogleFonts.orbitron(
                                        color: Colors.white)),
                                subtitle: Text(
                                  "₹${product.price.toStringAsFixed(2)}",
                                  style: GoogleFonts.orbitron(
                                      color: Colors.white70),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                initialValue:
                                    quantity == 0 ? '' : quantity.toString(),
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.orbitron(
                                    fontSize: 14, color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Qty",
                                  labelStyle: GoogleFonts.orbitron(
                                      fontSize: 12, color: Colors.white70),
                                  isDense: true,
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
                    color: const Color(0xFF2C2C2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Subtotal: ₹${subtotal.toStringAsFixed(2)}",
                              style: GoogleFonts.orbitron(
                                  color: Colors.white, fontSize: 14)),
                          Text("Tax (18%): ₹${tax.toStringAsFixed(2)}",
                              style: GoogleFonts.orbitron(
                                  color: Colors.white, fontSize: 14)),
                          const SizedBox(height: 6),
                          Text("Total: ₹${total.toStringAsFixed(2)}",
                              style: GoogleFonts.orbitron(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.tealAccent)),
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
                    label: Text("Generate & Print Invoice",
                        style: GoogleFonts.orbitron(fontSize: 16)),
                  ),
                ],
              ),
      ),
    );
  }
}
