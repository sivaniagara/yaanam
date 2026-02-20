import 'app_environment.dart';

class EnvironmentConfig {
  final String baseUrl;
  final bool enableLogs;

  const EnvironmentConfig({
    required this.baseUrl,
    required this.enableLogs,
  });

  static EnvironmentConfig fromEnv(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        return const EnvironmentConfig(
          baseUrl: "https://dev-api.yourserver.com",
          enableLogs: true,
        );

      case AppEnvironment.prod:
        return const EnvironmentConfig(
          baseUrl: "https://api.yourserver.com",
          enableLogs: false,
        );
    }
  }
}
