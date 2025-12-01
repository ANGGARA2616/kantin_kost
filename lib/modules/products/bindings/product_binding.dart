import 'package:get/get.dart';

import '../../../data/repositories/product_repository.dart';
import '../controllers/product_controller.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
