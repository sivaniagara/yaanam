import 'main_common.dart';
import 'core/environment/app_environment.dart';
import 'core/environment/app_brand.dart';

void main() {
  mainCommon(
    environment: AppEnvironment.dev,
    brand: AppBrand.yaanam,
  );
}
