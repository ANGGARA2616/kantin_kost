import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/product_model.dart';

class ProductDetailPage extends GetView<ProductController> {
  final CartController cartController = Get.find<CartController>();

  ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan gambar produk
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  Get.snackbar('Info', 'Fitur favorit akan segera hadir!');
                },
              ),
            ],
          ),
          // Detail produk
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk dan harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(product.category),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Status ketersediaan
                  Row(
                    children: [
                      Icon(
                        product.isAvailable ? Icons.check_circle: Icons.cancel,
                        size: 20,
                        color: product.isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.isAvailable ? 'Tersedia' : 'Habis',
                        style: TextStyle(
                          color: product.isAvailable ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.isAvailable) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.inventory_2  , size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Stok: ${product.stock}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Deskripsi produk
                  if (product.description != null && product.description!.isNotEmpty) ...[
                    Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Informasi tambahan
                  _buildProductInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom button untuk menambah ke keranjang
      bottomNavigationBar: _buildBottomBar(product),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.fork_left, // Ganti dengan icon yang tersedia
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Siap dalam 15-30 menit'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.delivery_dining, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Gratis antar ke kamar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity selector (hanya jika produk available)
          if (product.isAvailable) ...[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: () {
                      final currentQty = cartController.getQuantity(product);
                      if (currentQty > 0) {
                        cartController.decrementQuantity(product);
                      }
                    },
                  ),
                  Obx(() {
                    final quantity = cartController.getQuantity(product);
                    return Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      final currentQty = cartController.getQuantity(product);
                      if (currentQty < product.stock) {
                        cartController.incrementQuantity(product);
                      } else {
                        Get.snackbar(
                          'Stok Terbatas',
                          'Maaf, stok produk ini hanya ${product.stock}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Add to cart button
          Expanded(
            child: Obx(() {
              final quantityInCart = cartController.getQuantity(product);
              final isInCart = quantityInCart > 0;

              return ElevatedButton(
                onPressed: product.isAvailable
                    ? () {
                        if (isInCart) {
                          Get.toNamed('/cart');
                        } else {
                          cartController.addToCart(product);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isInCart
                      ? Colors.orange
                      : Theme.of(Get.context!).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isInCart) ...[
                      const Icon(Icons.shopping_cart, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      isInCart ? 'Lihat Keranjang ($quantityInCart)' : 'Tambah ke Keranjang',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Minuman':
        return Colors.blue;
      case 'Snack':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}