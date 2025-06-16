import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceProvider with ChangeNotifier {
  List<Invoice> _invoices = [];
  bool _loading = false;

  List<Invoice> get invoices => _invoices;
  bool get isLoading => _loading;

  Future<void> fetchInvoices() async {
    _loading = true;
    notifyListeners();
    _invoices = await InvoiceService.fetchInvoices();
    _loading = false;
    notifyListeners();
  }

  Future<bool> createInvoice(
      String? customerName, List<Map<String, dynamic>> items) async {
    final result = await InvoiceService.createInvoice(customerName, items);
    if (result) await fetchInvoices();
    return result;
  }

  Future<Invoice?> fetchInvoiceDetails(int id) async {
    return await InvoiceService.fetchInvoiceDetails(id);
  }
}
