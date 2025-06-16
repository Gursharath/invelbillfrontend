import 'dart:convert';
import '../constants/api_constants.dart';
import '../models/invoice.dart';
import 'api_service.dart';

class InvoiceService {
  static Future<List<Invoice>> fetchInvoices() async {
    final response =
        await ApiService.get(ApiConstants.invoices, withAuth: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => Invoice.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> createInvoice(
      String? customerName, List<Map<String, dynamic>> items) async {
    final response = await ApiService.post(
      ApiConstants.invoices,
      {
        'customer_name': customerName,
        'items': items,
      },
      withAuth: true,
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<Invoice?> fetchInvoiceDetails(int id) async {
    final response =
        await ApiService.get('${ApiConstants.invoices}/$id', withAuth: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Invoice.fromJson(data);
    }
    return null;
  }
}
