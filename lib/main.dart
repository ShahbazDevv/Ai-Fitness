import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('--- App Startup ---');
  
  // Load environment variables
  try {
    print('Main: Loading .env file...');
    await dotenv.load(fileName: ".env").timeout(const Duration(seconds: 5));
    print('Main: .env loaded. Keys found: ${dotenv.env.keys}');
    
    if (dotenv.env.isEmpty) {
      print('Main: Warning! .env file is empty or could not be parsed correctly.');
    }
  } catch (e) {
    print('Main: Critical error loading .env file: $e');
  }

  // Pre-initialize GetX bindings and services synchronously
  print('Main: Initializing dependencies...');
  final initialBinding = InitialBinding();
  initialBinding.dependencies();
  
  print('Main: Running app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'AI-Based Fitness',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
