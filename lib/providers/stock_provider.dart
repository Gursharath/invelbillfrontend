import 'package:flutter/material.dart';
import '../models/stock_log.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  List<StockLog> _logs = [];
  bool _loading = false;

  List<StockLog> get logs => _logs;
  bool get isLoading => _loading;

  /// Fetch all stock logs
  Future<void> fetchLogs() async {
    try {
      _loading = true;
      notifyListeners();

      final fetchedLogs = await StockService.fetchStockLogs();
      _logs = fetchedLogs;
    } catch (e) {
      debugPrint('Error fetching stock logs: $e');
      _logs = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Stock In action
  Future<bool> stockIn(int productId, int quantity) async {
    try {
      final result = await StockService.stockIn(productId, quantity);
      if (result) await fetchLogs();
      return result;
    } catch (e) {
      debugPrint('Stock In error: $e');
      return false;
    }
  }

  /// Stock Out action
  Future<bool> stockOut(int productId, int quantity) async {
    try {
      final result = await StockService.stockOut(productId, quantity);
      if (result) await fetchLogs();
      return result;
    } catch (e) {
      debugPrint('Stock Out error: $e');
      return false;
    }
  }
}
