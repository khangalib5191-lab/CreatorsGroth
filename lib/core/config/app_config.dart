import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.grocal.app/api/v1';

  static String get wsBaseUrl =>
      dotenv.env['WS_BASE_URL'] ?? 'wss://api.grocal.app/ws';

  static bool get useMockRepositories =>
      (dotenv.env['USE_MOCK_REPOSITORIES'] ?? 'true').toLowerCase() == 'true';

  static double get platformFeePercent =>
      double.tryParse(dotenv.env['PLATFORM_FEE_PERCENT'] ?? '10') ?? 10;

  static int get welcomeBonusCredits =>
      int.tryParse(dotenv.env['WELCOME_BONUS_CREDITS'] ?? '500') ?? 500;

  static int get initialReputationScore =>
      int.tryParse(dotenv.env['INITIAL_REPUTATION_SCORE'] ?? '100') ?? 100;
}
