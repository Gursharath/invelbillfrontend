import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceProvider>().fetchInvoices();
  }

  Future<void> _printInvoice(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE #${invoice.id}',
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            if (invoice.customerName != null &&
                invoice.customerName!.isNotEmpty)
              pw.Text("Customer: ${invoice.customerName!}"),
            pw.Text("Date: ${invoice.date.toLocal().toString().split(' ')[0]}"),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Product', 'Qty', 'Price', 'Total'],
              data: invoice.items.map((item) {
                final name = item.product.name;
                final qty = item.quantity;
                final price = item.product.price;
                final total = price * qty;
                return [
                  name,
                  qty.toString(),
                  '${price.toStringAsFixed(2)}',
                  '${total.toStringAsFixed(2)}',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Subtotal: ${invoice.subtotal.toStringAsFixed(2)}"),
                  pw.Text("Tax (18%): ${invoice.tax.toStringAsFixed(2)}"),
                  pw.Text("Total: ${invoice.total.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<InvoiceProvider>().fetchInvoices(),
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.invoices.isEmpty
              ? const Center(child: Text("No invoices found."))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.invoices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final invoice = provider.invoices[i];
                    return GestureDetector(
                      onTap: () async {
                        final fullInvoice = await context
                            .read<InvoiceProvider>()
                            .fetchInvoiceDetails(invoice.id);

                        if (fullInvoice != null) {
                          await _printInvoice(fullInvoice);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Failed to load invoice")),
                          );
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invoice #${invoice.id}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Customer: ${invoice.customerName ?? "N/A"}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Date: ${invoice.date.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total: ${invoice.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
