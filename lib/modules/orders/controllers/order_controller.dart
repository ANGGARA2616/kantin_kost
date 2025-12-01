import 'package:get/get.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository = Get.find();
  
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final ordersList = await _orderRepository.getMyOrders();
      orders.assignAll(ordersList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get pendingOrders => orders
      .where((order) => order.status == 'Pending')
      .toList();

  List<OrderModel> get cookingOrders => orders
      .where((order) => order.status == 'Dimasak')
      .toList();

  List<OrderModel> get deliveringOrders => orders
      .where((order) => order.status == 'Diantar')
      .toList();

  List<OrderModel> get completedOrders => orders
      .where((order) => order.status == 'Selesai')
      .toList();
}