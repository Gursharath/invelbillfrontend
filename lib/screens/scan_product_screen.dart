import 'package:flutter/material.dart';
import '../widgets/barcode_scanner_widget.dart';

class ScanProductScreen extends StatelessWidget {
  const ScanProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product")),
      body: BarcodeScannerWidget(
        onBarcodeScanned: (barcode) {
          Navigator.pop(context, barcode); // Only pop here
        },
      ),
    );
  }
}
