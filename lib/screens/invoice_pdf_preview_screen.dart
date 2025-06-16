import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePdfPreviewScreen extends StatelessWidget {
  const InvoicePdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real scenario, you'd load the invoice details and generate PDF document based on that
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Center(child: pw.Text('Invoice PDF Preview')),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Invoice PDF Preview")),
      body: PdfPreview(build: (format) => pdf.save()),
    );
  }
}
