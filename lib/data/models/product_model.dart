class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String category;
  final String? imagePath; // SIMPAN PATH SAJA, bukan full URL
  final bool isAvailable;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    this.imagePath, // Ganti dari imageUrl ke imagePath
    required this.isAvailable,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imagePath: json['image_path'] as String?, // Ganti image_url ke image_path
      isAvailable: json['is_available'] as bool,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_path': imagePath, // Ganti image_url ke image_path
      'is_available': isAvailable,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // METHOD BARU: Generate URL dari path
  String? get imageUrl {
    if (imagePath == null || imagePath!.isEmpty) return null;

    // Format URL Supabase Storage
    // Contoh: https://[project-ref].supabase.co/storage/v1/object/public/product_images/nasi-goreng.jpg
    const String supabaseUrl = 'YOUR_SUPABASE_URL'; // Ganti dengan URL Anda
    return '$supabaseUrl/storage/v1/object/public/product_images/$imagePath';
  }
}
