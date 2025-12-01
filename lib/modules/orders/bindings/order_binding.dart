import 'package:get/get.dart';

import '../../../data/repositories/order_repository.dart';
import '../controllers/order_controller.dart';

class OrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}