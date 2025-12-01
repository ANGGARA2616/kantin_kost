class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtTime;
  final DateTime createdAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtTime,
    required this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['products'] != null 
          ? (json['products']['name'] as String?) ?? 'Unknown Product'
          : 'Unknown Product',
      quantity: json['quantity'] as int,
      priceAtTime: (json['price_at_time'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_time': priceAtTime,
      'created_at': createdAt.toIso8601String(),
    };
  }
}