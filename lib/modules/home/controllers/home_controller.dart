import 'package:get/get.dart';

import '../../../modules/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find();

  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void logout() {
    _authController.logout();
  }
}
