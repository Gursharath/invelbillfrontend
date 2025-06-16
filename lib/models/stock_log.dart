class StockLog {
  final int id;
  final int productId;
  final String action;
  final int quantity;
  final DateTime date;

  StockLog({
    required this.id,
    required this.productId,
    required this.action,
    required this.quantity,
    required this.date,
  });

  factory StockLog.fromJson(Map<String, dynamic> json) {
    return StockLog(
      id: json['id'],
      productId: json['product_id'],
      action: json['type'], // 'in' or 'out'
      quantity: json['quantity'],
      date: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'type': action,
      'quantity': quantity,
      'created_at': date.toIso8601String(),
    };
  }
}
