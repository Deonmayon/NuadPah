import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> signUp(String email, String password, String firstname, String lastname) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'firstname': firstname,
          'lastname': lastname,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print('response is here !!!!!!!!!!!!!!!!!!!!!!!! ${response.statusCode}');
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to sign up: ${e.response?.data ?? e.message}');
    }
  }
}
