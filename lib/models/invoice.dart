import 'product.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class InvoiceItem {
  final Product product;
  final int quantity;

  InvoiceItem({required this.product, required this.quantity});
}

class Invoice {
  final int id;
  final String? customerName;
  final DateTime date;
  final List<InvoiceItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String? pdfUrl;

  Invoice({
    required this.id,
    required this.customerName,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.pdfUrl,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];

    final items = rawItems
        .map((item) {
          final productJson = item['product'];
          if (productJson == null) {
            debugPrint('⚠️ Skipping item with null product: $item');
            return null;
          }

          return InvoiceItem(
            product: Product.fromJson(productJson),
            quantity: item['quantity'] ?? 1,
          );
        })
        .whereType<InvoiceItem>()
        .toList();

    return Invoice(
      id: json['id'],
      customerName: json['customer_name'],
      date: DateTime.parse(json['created_at']),
      items: items,
      subtotal: _parseDouble(json['subtotal']),
      tax: _parseDouble(json['tax']),
      total: _parseDouble(json['total']),
      pdfUrl: json['pdf_url'],
    );
  }

  // ✅ Helper function to parse numbers or strings to double
  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
