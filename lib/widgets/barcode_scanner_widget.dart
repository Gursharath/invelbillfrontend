import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final Function(String barcode) onBarcodeScanned;

  const BarcodeScannerWidget({super.key, required this.onBarcodeScanned});

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: MobileScanner(
        onDetect: (capture) {
          if (_scanned) return;
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            setState(() => _scanned = true);
            widget.onBarcodeScanned(barcode);
            // Do NOT pop the context here!
          }
        },
      ),
    );
  }
}
