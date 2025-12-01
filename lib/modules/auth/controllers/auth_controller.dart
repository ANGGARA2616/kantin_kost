import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final SupabaseService _supabaseService = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    _checkAuthStatus();
    super.onInit();
  }

  void _checkAuthStatus() {
    isLoggedIn.value = _supabaseService.isLoggedIn;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authRepository.login(email, password);
      isLoggedIn.value = true;

      Get.offAllNamed('/home');
      Get.snackbar('Success', 'Login berhasil!');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Login Error', e.message);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Error', 'Terjadi kesalahan saat login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      String email, String password, String username, String roomNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authRepository.register(email, password, username, roomNumber);

      Get.offAllNamed('/login');
      Get.snackbar('Success', 'Registrasi berhasil! Silakan login.');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Register Error', e.message);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Error', 'Terjadi kesalahan saat registrasi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }
}
