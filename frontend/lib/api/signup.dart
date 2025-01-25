import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> signUp(String email, String password) async {
    try {
      final response = await _dio.post(
        '/signup',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to sign up: ${e.response?.data ?? e.message}');
    }
  }
}
