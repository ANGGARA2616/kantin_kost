import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../products/views/product_list_page.dart';
import '../../cart/views/cart_page.dart';
import '../../orders/views/order_history_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Kost 54'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              ProductListPage(),
              OrderHistoryPage(),
              CartPage(),
            ],
          )),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.changeTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_filled),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Pesanan',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart),
                selectedIcon: Icon(Icons.shopping_cart_checkout),
                label: 'Keranjang',
              ),
            ],
          )),
    );
  }
}