import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  String _searchQuery = '';
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    context.read<InvoiceProvider>().fetchInvoices();
  }

  DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  Future<void> _printReport(List<Invoice> invoices) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Invoice Report",
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Total Invoices: ${invoices.length}"),
            pw.Text(
              "Total Revenue: ₹${invoices.fold(0.0, (sum, inv) => sum + inv.total).toStringAsFixed(2)}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['ID', 'Customer', 'Date', 'Total'],
              data: invoices
                  .map((inv) => [
                        inv.id.toString(),
                        inv.customerName ?? 'N/A',
                        inv.date.toLocal().toString().split(' ')[0],
                        '₹${inv.total.toStringAsFixed(2)}'
                      ])
                  .toList(),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _exportToExcel(List<Invoice> invoices) async {
    final excel = Excel.createExcel();
    final sheet = excel['Invoices'];

    sheet.appendRow(['ID', 'Customer', 'Date', 'Total']);
    for (var inv in invoices) {
      sheet.appendRow([
        inv.id,
        inv.customerName ?? 'N/A',
        inv.date.toLocal().toString().split(' ')[0],
        inv.total.toStringAsFixed(2)
      ]);
    }

    final bytes = excel.encode()!;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice_report.xlsx');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Invoice Report');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();
    final invoices = provider.invoices;

    final filteredInvoices = invoices.where((invoice) {
      final matchesSearch = invoice.customerName
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ==
              true ||
          invoice.id.toString().contains(_searchQuery);

      final matchesDate = _selectedRange == null ||
          (onlyDate(invoice.date)
                  .isAtSameMomentAs(onlyDate(_selectedRange!.start)) ||
              onlyDate(invoice.date)
                  .isAtSameMomentAs(onlyDate(_selectedRange!.end)) ||
              (onlyDate(invoice.date)
                      .isAfter(onlyDate(_selectedRange!.start)) &&
                  onlyDate(invoice.date)
                      .isBefore(onlyDate(_selectedRange!.end))));

      return matchesSearch && matchesDate;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalRevenue =
        filteredInvoices.fold(0.0, (sum, inv) => sum + inv.total);
    final uniqueCustomers = filteredInvoices
        .map((e) => e.customerName)
        .whereNotNull()
        .toSet()
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice History",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.tealAccent,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<InvoiceProvider>().fetchInvoices(),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Print Report',
            onPressed: () => _printReport(filteredInvoices),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export to Excel',
            onPressed: () => _exportToExcel(filteredInvoices),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or invoice #',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    style: GoogleFonts.poppins(),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: 'Filter by Date Range',
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _selectedRange = picked);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Date Filter',
                  onPressed: () => setState(() => _selectedRange = null),
                )
              ],
            ),
          ),
          if (_selectedRange != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Range: ${_selectedRange!.start.toLocal().toString().split(' ')[0]} to ${_selectedRange!.end.toLocal().toString().split(' ')[0]}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard("Invoices", filteredInvoices.length.toString(),
                    Colors.blue),
                _buildStatCard("Revenue", "₹${totalRevenue.toStringAsFixed(2)}",
                    Colors.green),
                _buildStatCard(
                    "Customers", uniqueCustomers.toString(), Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredInvoices.isEmpty
                    ? Center(
                        child: Text("No invoices found.",
                            style: GoogleFonts.poppins()))
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredInvoices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final invoice = filteredInvoices[i];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Invoice #${invoice.id}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Customer: ${invoice.customerName ?? "N/A"}',
                                      style: GoogleFonts.poppins(fontSize: 14)),
                                  Text(
                                      'Date: ${invoice.date.toLocal().toString().split(' ')[0]}',
                                      style: GoogleFonts.poppins(fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        'Total: ₹${invoice.total.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.poppins(fontSize: 14))
      ],
    );
  }
}
