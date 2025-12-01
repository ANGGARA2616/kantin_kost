import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository = Get.find();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final productsList = await _productRepository.getProducts();
      products.assignAll(productsList);
      filteredProducts.assignAll(productsList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      // Filter secara manual di Flutter
      filteredProducts.assignAll(
          products.where((product) => product.category == category).toList());
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filterByCategory(selectedCategory.value);
    } else {
      filteredProducts.assignAll(products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              (product.description
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false))
          .toList());
    }
  }
}
