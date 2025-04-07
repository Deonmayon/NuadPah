import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://senuadpahdocker-production.up.railway.app',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  // Sign up
  Future<Response> signUp(
      String email, String password, String firstname, String lastname) async {
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // For incorrect password
        throw "รหัสผ่านไม่ถูกต้อง";
      }
      // For other errors (network, server, etc.)
      throw 'Failed to sign in: ${e.message}';
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

  // Get user's data from token
  Future<Response> getUserData(String token) async {
    try {
      final response = await _dio.post(
        '/auth/userdata',
        data: {
          'email': "",
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      throw Exception(
          'Failed to get email from token: ${e.response?.data ?? e.message}');
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
      final response = await _dio.put(
        '/auth/resetpw/$email',
        data: {
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
      throw Exception(
          'Failed to reset password: ${e.response?.data ?? e.message}');
    }
  }

  // Update user data
  Future<Response> updateUserData(int id, String email, String newpw,
      String firstname, String lastname, String imageName) async {
    try {
      final response = await _dio.put(
        '/admin/edit-user/$id',
        data: {
          'email': email,
          'password': newpw,
          'firstname': firstname,
          'lastname': lastname,
          'image_name': imageName,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception(
          'Failed to update user data: ${e.response?.data ?? e.message}');
    }
  }

  // Send image to supabase
  Future<Response> sendImageToSupabase(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/image/upload',
        data: formData,
      );

      return response;
    } on DioError catch (e) {
      throw Exception(
          'Failed to send image to supabase: ${e.response?.data ?? e.message}');
    }
  }

  // Send Report
  Future<Response> sendReport(String email, String title, String detail) async {
    try {
      final response = await _dio.post(
        '/user/send-report',
        data: {
          'email': email,
          'title': title,
          'detail': detail,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioError catch (e) {
      throw Exception(
          'Failed to send report: ${e.response?.data ?? e.message}');
    }
  }
}
