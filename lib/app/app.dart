import 'package:flutter/material.dart';
import '../core/environment/app_config.dart';
import '../core/router/app_router.dart';
import '../features/introduction/presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: brandConfig.appName,
      theme: brandConfig.themeData,
    );
  }
}