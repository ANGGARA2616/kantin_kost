import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String status;
  final String roomNumber;
  final String? notes;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.roomNumber,
    this.notes,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      roomNumber: json['room_number'] as String,
      notes: json['notes'] as String?,
      paymentMethod: json['payment_method'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_price': totalPrice,
      'status': status,
      'room_number': roomNumber,
      'notes': notes,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
