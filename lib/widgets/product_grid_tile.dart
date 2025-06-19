import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final Color? stockColor;
  final String? stockStatus;

  const ProductGridTile({
    super.key,
    required this.product,
    this.stockColor,
    this.stockStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image and Status Badge
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              if (stockStatus != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: stockColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stockStatus!,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Product Name
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Barcode
        Text(
          product.barcode,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // Price and Quantity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: stockColor?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: stockColor ?? Colors.grey, width: 0.5),
              ),
              child: Text(
                '${product.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: stockColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-product',
                    arguments: product,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: const Size(0, 28),
                ),
                child: const Text('Edit', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: const Size(0, 28),
                ),
                child: const Text('Delete', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add your delete logic here
              // context.read<ProductProvider>().deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
