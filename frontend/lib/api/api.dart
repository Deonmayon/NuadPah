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

  // Get email from token
  Future<Response> getToken(String token) async {
    try {
      final response = await _dio.get(
        '/auth/userdata',
        data: {
          'token': token,
        },
      );

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to get email from token: ${e.response?.data ?? e.message}');
    }
  }

  // Verify OTP
  Future<Response> verifyOTP(String email, String otp) async {
    try {
      final response = await _dio.post(
        '/auth/verifyotp',
        data: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to verify OTP: ${e.response?.data ?? e.message}');
    }
  }

  // Reset password
  Future<Response> resetPassword(String email, String newpw) async {
    try {
      final response = await _dio.post(
        '/auth/resetpw',
        data: {
          'email': email,
          'newpw': newpw,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception('Failed to reset password: ${e.response?.data ?? e.message}');
    }
  }
}
