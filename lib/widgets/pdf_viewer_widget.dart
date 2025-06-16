import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfViewerWidget extends StatelessWidget {
  final pw.Document document;

  const PdfViewerWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => document.save(),
    );
  }
}
