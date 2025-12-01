import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

import '../../core/services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService = Get.find();

  Future<void> login(String email, String password) async {
    final response = await _supabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Login failed');
    }
  }

  Future<void> register(
      String email, String password, String username, String roomNumber) async {
    // Create user in Auth
    final authResponse = await _supabaseService.client.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw const AuthException('Registration failed');
    }

    // Create profile in profiles table
    await _supabaseService.client.from('profiles').upsert({
      'id': authResponse.user!.id,
      'username': username,
      'room_number': roomNumber,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> logout() async {
    await _supabaseService.client.auth.signOut();
  }

  User? get currentUser => _supabaseService.currentUser;
}
