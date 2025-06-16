import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${product.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Barcode: ${product.barcode}"),
            const SizedBox(height: 10),
            Text("Price: ${product.price}"),
            const SizedBox(height: 10),
            Text("Quantity: ${product.quantity}"),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
