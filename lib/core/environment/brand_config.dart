import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_brand.dart';

class BrandConfig {
  final ThemeData themeData;
  final String appName;

  const BrandConfig({
    required this.themeData,
    required this.appName,
  });

  static BrandConfig fromBrand(AppBrand brand) {
    switch (brand) {
      case AppBrand.yaanam:
        return BrandConfig(
          themeData: AppTheme.lightTheme,
          appName: "Yaanam",
        );
      case AppBrand.clientA:
        return BrandConfig(
          themeData: AppTheme.lightTheme,
          appName: "Client A",
        );
    }
  }
}
