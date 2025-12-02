import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../../../core/constants/app_constants.dart'; // TAMBAHKAN IMPORT INI

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: Obx(() {
        if (controller.isCartEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Keranjang kosong',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItem(item);
                },
              ),
            ),
            _buildTotalSection(),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image - PERBAIKI DI SINI
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: item.product.imagePath != null // GANTI: imagePath bukan imageUrl
                    ? DecorationImage(
                        image: NetworkImage(
                          AppConstants.getProductImageUrl(item.product.imagePath!), // PAKAI HELPER
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.product.imagePath == null // GANTI: imagePath bukan imageUrl
                  ? const Icon(Icons.fastfood, color: Colors.grey) // Icon yang lebih sesuai
                  : null,
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${item.product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => controller.decrementQuantity(item.product),
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.incrementQuantity(item.product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    'Rp ${controller.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/checkout'),
              child: const Text('Lanjut ke Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}