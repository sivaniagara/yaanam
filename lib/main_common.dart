import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/environment/app_config.dart';
import 'core/environment/app_environment.dart';
import 'core/environment/app_brand.dart';
import 'core/environment/environment_config.dart';
import 'core/environment/brand_config.dart';

void mainCommon({
  required AppEnvironment environment,
  required AppBrand brand,
}) {
  envConfig = EnvironmentConfig.fromEnv(environment);
  brandConfig = BrandConfig.fromBrand(brand);

  runApp(const MyApp());
}
