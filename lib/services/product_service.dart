import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await ApiService.get(ApiConstants.products, withAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      // Optionally log the error
    }
    return [];
  }

  static Future<Product?> fetchProductByBarcode(String barcode) async {
    try {
      final response = await ApiService.get('${ApiConstants.barcode}/$barcode',
          withAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data);
      }
    } catch (e) {
      // Optionally log the error
    }
    return null;
  }

  static Future<bool> addProduct(Product product) async {
    try {
      final response = await ApiService.post(
          ApiConstants.products, product.toJson(),
          withAuth: true);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // Optionally log the error
      return false;
    }
  }

  static Future<bool> updateProduct(Product product) async {
    try {
      final response = await ApiService.put(
          '${ApiConstants.products}/${product.id}', product.toJson(),
          withAuth: true);
      return response.statusCode == 200;
    } catch (e) {
      // Optionally log the error
      return false;
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await ApiService.delete('${ApiConstants.products}/$id',
          withAuth: true);
      return response.statusCode == 200;
    } catch (e) {
      // Optionally log the error
      return false;
    }
  }

  static Future<int> getProductCount() async {
    final response = await ApiService.get(
        '${ApiConstants.baseUrl}/product/count',
        withAuth: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['total'];
    }
    return 0;
  }
}
