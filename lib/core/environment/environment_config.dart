import 'app_environment.dart';

class EnvironmentConfig {
  final String baseUrl;
  final bool enableLogs;
  final String googleMapsApiKey;

  const EnvironmentConfig({
    required this.baseUrl,
    required this.enableLogs,
    required this.googleMapsApiKey,
  });

  static EnvironmentConfig fromEnv(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        return const EnvironmentConfig(
          baseUrl: "https://dev-api.yourserver.com",
          enableLogs: true,
          googleMapsApiKey: "AIzaSyA6xsymZl7I6k6Xl56Si1XxADg2qAccUkQ",
        );

      case AppEnvironment.prod:
        return const EnvironmentConfig(
          baseUrl: "https://api.yourserver.com",
          enableLogs: false,
          googleMapsApiKey: "AIzaSyA6xsymZl7I6k6Xl56Si1XxADg2qAccUkQ",
        );
    }
  }
}
