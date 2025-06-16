import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _loading = false;

  List<Product> get products => _products;
  bool get isLoading => _loading;

  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();
    _products = await ProductService.fetchProducts();
    _loading = false;
    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    final result = await ProductService.addProduct(product);
    if (result) await fetchProducts();
    return result;
  }

  Future<bool> updateProduct(Product product) async {
    final result = await ProductService.updateProduct(product);
    if (result) await fetchProducts();
    return result;
  }

  Future<bool> deleteProduct(int id) async {
    final result = await ProductService.deleteProduct(id);
    if (result) await fetchProducts();
    return result;
  }
}
