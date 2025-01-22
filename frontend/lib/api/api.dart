import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Sign up
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

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to sign up: ${e.response?.data ?? e.message}');
    }
  }

  // Sign in
  Future<Response> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/signin',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to sign in: ${e.response?.data ?? e.message}');
    }
  }

  // Send OTP
  Future<Response> sendOTP(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgetpw',
        data: {
          'email': email,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to send OTP: ${e.response?.data ?? e.message}');
    }
  }
}
