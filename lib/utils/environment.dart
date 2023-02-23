import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get productBaseUrl => '${dotenv.env['BASE_URL']}/products';
  static String get orderBaseUrl => '${dotenv.env['BASE_URL']}/orders';
}
