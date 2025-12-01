import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/services/location_service.dart'; // Tambahkan
import 'core/services/map_service.dart'; // Tambahkan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  
  // Initialize services
  await Get.putAsync(() => SupabaseService().init());
  await Get.putAsync(() => LocationService().init()); // Tambahkan
  await Get.putAsync(() => MapService().init()); // Tambahkan
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kantin Kost 54',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
    );
  }

  String _getInitialRoute() {
    final supabaseService = Get.find<SupabaseService>();
    return supabaseService.isLoggedIn ? AppRoutes.HOME : AppRoutes.LOGIN;
  }
}