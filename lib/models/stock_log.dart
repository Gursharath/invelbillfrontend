class StockLog {
  final int id;
  final int productId;
  final String action; // "in" or "out"
  final int quantity;
  final DateTime date;

  StockLog({
    required this.id,
    required this.productId,
    required this.action,
    required this.quantity,
    required this.date,
  });

  factory StockLog.fromJson(Map<String, dynamic> json) => StockLog(
        id: json['id'],
        productId: json['product_id'],
        action: json['action'],
        quantity: json['quantity'],
        date: DateTime.parse(json['created_at']),
      );
}
