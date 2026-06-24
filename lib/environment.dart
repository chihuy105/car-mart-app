import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

/// Per-flavor configuration backed by a `.env` file, with a hardcoded fallback
/// so the app still runs when the `.env` file is missing on a machine.
class EnvironmentConfig {
  EnvironmentConfig(this.environment);

  final Environment environment;

  static const _fallbackBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const _fallbackSgCarMartUrl = 'https://www.sgcarmart.com';

  String get _fileName => switch (environment) {
        Environment.development => '.env.development',
        Environment.staging => '.env.staging',
        Environment.production => '.env.production',
      };

  Future<void> load() async {
    try {
      await dotenv.load(fileName: _fileName);
    } on Object {
      // Missing/unreadable .env — fall back to compiled-in defaults.
    }
  }

  String get baseUrl => dotenv.isInitialized
      ? dotenv.maybeGet('API_BASE_URL', fallback: _fallbackBaseUrl) ??
          _fallbackBaseUrl
      : _fallbackBaseUrl;

  String get sgCarMartUrl => dotenv.isInitialized
      ? dotenv.maybeGet('SGCARMART_URL', fallback: _fallbackSgCarMartUrl) ??
          _fallbackSgCarMartUrl
      : _fallbackSgCarMartUrl;

  bool get isProduction => environment == Environment.production;
}
