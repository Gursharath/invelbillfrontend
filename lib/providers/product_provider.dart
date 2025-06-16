import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _loading = false;
  int _totalCount = 0;

  List<Product> get products => _products;
  bool get isLoading => _loading;
  int get totalCount => _totalCount;

  // Fetch product list and count together
  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();

    _products = await ProductService.fetchProducts();
    _totalCount = await ProductService.getProductCount();

    _loading = false;
    notifyListeners();
  }

  // Add a product and update list & count
  Future<bool> addProduct(Product product) async {
    final result = await ProductService.addProduct(product);
    if (result) {
      await fetchProducts();
    }
    return result;
  }

  // Update a product and refresh data
  Future<bool> updateProduct(Product product) async {
    final result = await ProductService.updateProduct(product);
    if (result) {
      await fetchProducts();
    }
    return result;
  }

  // Delete a product and refresh data
  Future<bool> deleteProduct(int id) async {
    final result = await ProductService.deleteProduct(id);
    if (result) {
      await fetchProducts();
    }
    return result;
  }

  // Only fetch product count (for dashboard)
  Future<void> fetchProductCount() async {
    _totalCount = await ProductService.getProductCount();
    notifyListeners();
  }
}
