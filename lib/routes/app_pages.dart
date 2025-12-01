import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/products/bindings/product_binding.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/orders/bindings/order_binding.dart';
import '../modules/home/views/home_page.dart';
import '../modules/products/views/product_list_page.dart';
import '../modules/products/views/product_detail_page.dart';
import '../modules/cart/views/cart_page.dart';
import '../modules/cart/views/checkout_page.dart';
import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/map_page.dart';
import '../modules/orders/views/order_history_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      bindings: [
        AuthBinding(),
        HomeBinding(),
        ProductBinding(),
        OrderBinding(),
        CartBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.PRODUCTS,
      page: () => const ProductListPage(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_DETAIL,
      page: () => ProductDetailPage(),
    ),
    GetPage(
      name: AppRoutes.CART,
      page: () => const CartPage(),
    ),
    GetPage(
      name: AppRoutes.CHECKOUT,
      page: () => CheckoutPage(),
    ),
    GetPage(
      name: AppRoutes.ORDER_HISTORY,
      page: () => const OrderHistoryPage(),
    ),
    GetPage(
      name: AppRoutes.MAP,
      page: () => MapPage(),
      binding: LocationBinding(), // Kita perlu buat ini
    ),
  ];
}
