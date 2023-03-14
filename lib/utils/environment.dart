import 'package:flutter_config/flutter_config.dart';

class Environment {
  static final productBaseUrl =
      '${FlutterConfig.get('BASE_URL')}/products';
  static String get orderBaseUrl => '${FlutterConfig.get('BASE_URL')}/orders';
  static String get userFavorites =>
      '${FlutterConfig.get('BASE_URL')}/userFavorites';
  static final apiKey = '${FlutterConfig.get('API_KEY')}';
  // static String get authUrl => '${dotenv.env['AUTH_URL']}';
}
