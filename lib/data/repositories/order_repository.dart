import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_service.dart';
import '../models/order_model.dart';
import '../../modules/cart/controllers/cart_controller.dart';

class OrderRepository {
  final SupabaseService _supabaseService = Get.find();

  Future<void> createOrder({
    required List<CartItem> cartItems,
    required String roomNumber,
    required String notes,
    required String paymentMethod,
  }) async {
    try {
      final totalPrice = cartItems.fold(0.0, (total, item) => 
        total + (item.product.price * item.quantity)
      );

      // Insert order
      final orderResponse = await _supabaseService.client
          .from('orders')
          .insert({
            'user_id': _supabaseService.currentUser!.id,
            'total_price': totalPrice,
            'room_number': roomNumber,
            'notes': notes,
            'payment_method': paymentMethod,
          })
          .select()
          .single();

      final orderId = orderResponse['id'] as String;

      // Insert order items
      for (final item in cartItems) {
        await _supabaseService.client
            .from('order_items')
            .insert({
              'order_id': orderId,
              'product_id': item.product.id,
              'quantity': item.quantity,
              'price_at_time': item.product.price,
            });
      }

    } on PostgrestException catch (e) {
      throw Exception('Error creating order: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _supabaseService.client
          .from('orders')
          .select('''
            *,
            order_items (
              *,
              products (*)
            )
          ''')
          .eq('user_id', _supabaseService.currentUser!.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Error fetching orders: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Stream<List<OrderModel>> getMyOrdersStream() {
    return _supabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', _supabaseService.currentUser!.id)
        .order('created_at', ascending: false)
        .map((event) => event
            .map((json) => OrderModel.fromJson(json))
            .toList());
  }
}