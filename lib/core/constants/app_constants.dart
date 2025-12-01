class AppConstants {
  // GANTI DENGAN URL SUPABASE ANDA
  static const String supabaseUrl = 'https://bxtvvjesjeheyqlcvkzr.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ4dHZ2amVzamVoZXlxbGN2a3pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1MDY4NDEsImV4cCI6MjA4MDA4Mjg0MX0.-DUAeM6dnTALaUqAW8GBEsOFdXzUglgYmoCLXRu6cHk';

  // Storage Configuration
  static const String productImagesBucket = 'product-images';

  // Helper method untuk generate image URL
  static String getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return ''; // Return empty string jika tidak ada gambar
    }
    return '$supabaseUrl/storage/v1/object/public/$productImagesBucket/$imagePath';
  }

  static const String appName = 'Kantin Kost 54';
}

class AppRoutes {
  static const String SPLASH = '/';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String HOME = '/home';
  static const String PRODUCTS = '/products';
  static const String PRODUCT_DETAIL = '/product_detail';
  static const String CART = '/cart';
  static const String CHECKOUT = '/checkout';
  static const String ORDER_HISTORY = '/order_history';
  static const String PROFILE = '/profile';
}
