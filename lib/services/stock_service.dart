import 'dart:convert';
import '../constants/api_constants.dart';
import '../models/stock_log.dart';
import 'api_service.dart';

class StockService {
  static Future<bool> stockIn(int productId, int quantity) async {
    final response = await ApiService.post(
      ApiConstants.stockIn,
      {'product_id': productId, 'quantity': quantity},
      withAuth: true,
    );
    return response.statusCode == 200;
  }

  static Future<bool> stockOut(int productId, int quantity) async {
    final response = await ApiService.post(
      ApiConstants.stockOut,
      {'product_id': productId, 'quantity': quantity},
      withAuth: true,
    );
    return response.statusCode == 200;
  }

  static Future<List<StockLog>> fetchStockLogs() async {
    final response =
        await ApiService.get(ApiConstants.stockLogs, withAuth: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => StockLog.fromJson(e)).toList();
    }
    return [];
  }
}
