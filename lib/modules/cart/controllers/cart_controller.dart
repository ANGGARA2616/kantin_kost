import 'package:get/get.dart';

import '../../../data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString roomNumber = ''.obs;
  final RxString notes = ''.obs;
  final RxString paymentMethod = 'Cash'.obs;

  double get totalPrice {
    return cartItems.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  void addToCart(ProductModel product) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity++;
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    cartItems.refresh();
    Get.snackbar('Success', '${product.name} added to cart');
  }

  void removeFromCart(ProductModel product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    cartItems.refresh();
  }

  void updateQuantity(ProductModel product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity = quantity;
      cartItems.refresh();
    }
  }

  void incrementQuantity(ProductModel product) {
    updateQuantity(product, getQuantity(product) + 1);
  }

  void decrementQuantity(ProductModel product) {
    updateQuantity(product, getQuantity(product) - 1);
  }

  int getQuantity(ProductModel product) {
    final item =
        cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    return item?.quantity ?? 0;
  }

  void clearCart() {
    cartItems.clear();
  }

  bool get isCartEmpty => cartItems.isEmpty;
}
