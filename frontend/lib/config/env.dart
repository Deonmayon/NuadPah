import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get googleMapsAPIKey {
    final key = dotenv.env['GOOGLEMAPS_API_KEY'];
    if (key == null) {
      throw Exception('GOOGLEMAPS_API_KEY is not set in .env file');
    }
    return key;
  }

  static String get apiBaseUrl {
    final key = dotenv.env['API_BASE_URL'];
    if (key == null) {
      throw Exception('API_BASE_URL is not set in .env file');
    }
    return key;
  }
}
