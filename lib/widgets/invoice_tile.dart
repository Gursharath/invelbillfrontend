import 'package:flutter/material.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';

class InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onTap;

  const InvoiceTile({super.key, required this.invoice, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt, size: 40),
      title: Text('Invoice #${invoice.id}'),
      subtitle: Text(
          'Date: ${DateFormat('yyyy-MM-dd').format(invoice.date)}\nTotal: ₹${invoice.total.toStringAsFixed(2)}'),
      onTap: onTap,
    );
  }
}
