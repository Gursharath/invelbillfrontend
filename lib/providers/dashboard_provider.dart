import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardProvider with ChangeNotifier {
  int totalQuantity = 0;
  int lowStockCount = 0;
  double todaySales = 0.0;

  Future<void> fetchDashboardStats() async {
    final url = Uri.parse('http://192.168.1.20:8000/api/dashboard/stats');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      // Add this if using Sanctum: 'Authorization': 'Bearer YOUR_TOKEN',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      totalQuantity = data['total_quantity'];
      lowStockCount = data['low_stock_count'];
      todaySales = double.tryParse(data['today_sales'].toString()) ?? 0.0;
      notifyListeners();
    } else {
      throw Exception('Failed to fetch dashboard stats');
    }
  }
}
