import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import 'product_detail_page.dart';
import '../../../data/models/product_model.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Kantin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(controller),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All', ''),
          _buildCategoryChip('Makanan', 'Makanan'),
          _buildCategoryChip('Minuman', 'Minuman'),
          _buildCategoryChip('Snack', 'Snack'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final isSelected = controller.selectedCategory.value == category;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.filterByCategory(category),
        );
      }),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(() => ProductDetailPage(), arguments: product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  image: product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imageUrl == null
                    ? const Icon(Icons.fastfood, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 8),
              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Product Price
              Text(
                'Rp ${product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(Get.context!).colorScheme.primary,
                ),
              ),
              const Spacer(),
              // Availability
              Row(
                children: [
                  Icon(
                    product.isAvailable ? Icons.check_circle : Icons.cancel,
                    size: 12,
                    color: product.isAvailable ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.isAvailable ? 'Available' : 'Habis',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final ProductController controller;
  final RxString _searchQuery = ''.obs;

  ProductSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _searchQuery.value = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Gunakan delayed execution untuk menghindari build conflict
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query != _searchQuery.value) {
        _searchQuery.value = query;
        controller.searchProducts(query);
      }
    });
    
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Gunakan delayed execution untuk menghindari build conflict
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query != _searchQuery.value) {
        _searchQuery.value = query;
        controller.searchProducts(query);
      }
    });

    if (query.isEmpty) {
      return _buildRecentSearches();
    }
    
    return _buildSearchResults();
  }

  Widget _buildRecentSearches() {
    return const Center(
      child: Text('Ketik untuk mencari produk...'),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.filteredProducts.isEmpty && query.isNotEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Produk tidak ditemukan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = controller.filteredProducts[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailPage(), arguments: product);
          close(Get.context!, null);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  image: product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imageUrl == null
                    ? const Icon(Icons.fastfood, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(Get.context!).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    product.isAvailable ? Icons.check_circle : Icons.cancel,
                    size: 12,
                    color: product.isAvailable ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.isAvailable ? 'Available' : 'Habis',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
