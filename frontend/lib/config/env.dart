import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get googleMapsAPIKey {
    final key = dotenv.env['GOOGLEMAPS_API_KEY'];
    if (key == null) {
      throw Exception('GOOGLEMAPS_API_KEY is not set in .env file');
    }
    return key;
  }

  // เพิ่มตัวแปรอื่นๆ ตามต้องการ
  static bool get isDebug => dotenv.env['DEBUG'] == 'true';
}
