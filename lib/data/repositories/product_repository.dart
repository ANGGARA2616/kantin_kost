import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_service.dart';
import '../models/product_model.dart';

class ProductRepository extends GetxService {
  final SupabaseService _supabaseService = Get.find();

  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      // Method 1: Gunakan filter dengan cara yang berbeda
      final query = _supabaseService.client
          .from('products')
          .select('*')
          .order('created_at', ascending: false);

      final response = await query;

      // Filter secara manual di Flutter jika perlu
      List<ProductModel> products = (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();

      if (category != null && category.isNotEmpty) {
        products =
            products.where((product) => product.category == category).toList();
      }

      return products;
    } on PostgrestException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Alternatif Method 2: Jika ingin filter di query database
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _supabaseService.client
          .from('products')
          .select()
          .eq('category', category) // Coba method eq langsung
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('products')
          .select()
          .eq('id', id)
          .single();

      return ProductModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
