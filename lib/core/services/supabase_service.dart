import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  static SupabaseService get to => Get.find();
  
  final SupabaseClient client = Supabase.instance.client;
  
  Future<SupabaseService> init() async {
    return this;
  }
  
  User? get currentUser => client.auth.currentUser;
  
  bool get isLoggedIn => currentUser != null;
}