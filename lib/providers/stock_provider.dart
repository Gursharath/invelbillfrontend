import 'package:flutter/material.dart';
import '../models/stock_log.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  List<StockLog> _logs = [];
  bool _loading = false;

  List<StockLog> get logs => _logs;
  bool get isLoading => _loading;

  Future<void> fetchLogs() async {
    _loading = true;
    notifyListeners();
    _logs = await StockService.fetchStockLogs();
    _loading = false;
    notifyListeners();
  }

  Future<bool> stockIn(int productId, int quantity) async {
    final result = await StockService.stockIn(productId, quantity);
    if (result) await fetchLogs();
    return result;
  }

  Future<bool> stockOut(int productId, int quantity) async {
    final result = await StockService.stockOut(productId, quantity);
    if (result) await fetchLogs();
    return result;
  }
}
