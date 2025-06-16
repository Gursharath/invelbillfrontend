import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductTile({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.imagePath != null
          ? Image.network(product.imagePath!,
              width: 40, height: 40, fit: BoxFit.cover)
          : const Icon(Icons.inventory_2, size: 40),
      title: Text(product.name),
      subtitle: Text(
          'Barcode: ${product.barcode}  Price: ₹${product.price}\nQty: ${product.quantity}'),
      onTap: onTap,
    );
  }
}
