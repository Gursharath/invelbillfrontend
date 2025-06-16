class Product {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final int quantity;
  final String? imagePath;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.quantity,
    this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'],
        barcode: json['barcode'],
        price: json['price'] is num
            ? (json['price'] as num).toDouble()
            : double.tryParse(json['price'].toString()) ?? 0.0,
        quantity: json['quantity'] is num
            ? (json['quantity'] as num).toInt()
            : int.tryParse(json['quantity'].toString()) ?? 0,
        imagePath: json['image_path'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'barcode': barcode,
        'price': price,
        'quantity': quantity,
        'image_path': imagePath,
      };
}
