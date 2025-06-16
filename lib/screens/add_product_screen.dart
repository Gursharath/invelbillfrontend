import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _barcode = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Product Details",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Product Name
              CustomTextField(
                controller: _name,
                label: "Product Name",
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),

              // Barcode + Scanner
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _barcode,
                      label: "Barcode",
                      validator: Validators.validateRequired,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner, size: 30),
                    tooltip: "Scan Barcode",
                    onPressed: () async {
                      final code =
                          await Navigator.pushNamed(context, '/scan-product');
                      if (code is String) _barcode.text = code;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              CustomTextField(
                controller: _price,
                label: "Price (₹)",
                keyboardType: TextInputType.number,
                validator: Validators.validateNumber,
              ),
              const SizedBox(height: 16),

              // Quantity
              CustomTextField(
                controller: _quantity,
                label: "Quantity",
                keyboardType: TextInputType.number,
                validator: Validators.validateNumber,
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              // Submit Button
              const SizedBox(height: 16),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save Product"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: theme.primaryColor,
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        final success =
                            await context.read<ProductProvider>().addProduct(
                                  Product(
                                    id: 0,
                                    name: _name.text.trim(),
                                    barcode: _barcode.text.trim(),
                                    price: double.parse(_price.text),
                                    quantity: int.parse(_quantity.text),
                                  ),
                                );

                        setState(() {
                          _loading = false;
                        });

                        if (success) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _error = "Failed to add product";
                          });
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
