import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Get all massages
  Future<Response> getAllMassages() async {
    try {
      final response = await _dio.get('/massage/single-list');
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to get all massages: ${e.response?.data ?? e.message}');
    }
  }

  // Get all Set massages
  Future<Response> getAllSetMassages() async {
    try {
      final response = await _dio.get('/massage/set-list');
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to get all Set massages: ${e.response?.data ?? e.message}');
    }
  }

  // Add massage
  Future<Response> addMassage(String name, String type, int round, int time,
      String detail, String image) async {
    try {
      final response = await _dio.post('/massage/add-single-massage',
          data: {
            'mt_name': name,
            'mt_type': type,
            'mt_round': round,
            'mt_time': time,
            'mt_detail': detail,
            'mt_image': image
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Reccomend massages
  Future<Response> getReccomendMassages(String email) async {
    try {
      final response = await _dio.post('/massage/recommend',
          data: {
            'email': email,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Get Favorite Single Massage
  Future<Response> getFavSingle(String email) async {
    try {
      final response = await _dio.post('/user/get-fav-single',
          data: {
            'email': email,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Favorite a Single Massage
  Future<Response> favSingle(String email, int id) async {
    try {
      final response = await _dio.post('/user/fav-single',
          data: {
            'email': email,
            'mt_id': id,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Unfavorite a Single Massage
  Future<Response> unfavSingle(String email, int id) async {
    try {
      final response = await _dio.delete('/user/unfav-single/$email/$id',
          data: {
            'email': email,
            'mt_id': id,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Get Favorite Set Massage
  Future<Response> getFavSet(String email) async {
    try {
      final response = await _dio.post('/user/get-fav-set',
          data: {
            'email': email,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Favorite a Set Massage
  Future<Response> favSet(String email, int id) async {
    try {
      final response = await _dio.post('/user/fav-set',
          data: {
            'email': email,
            'ms_id': id,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }

  // Unfavorite a Set Massage
  Future<Response> unfavSet(String email, int id) async {
    try {
      final response = await _dio.delete('/user/unfav-set/$email/$id',
          data: {
            'email': email,
            'ms_id': id,
          },
          options: Options(headers: {'Content-Type': 'application/json'}));

      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to add massage: ${e.response?.data ?? e.message}');
    }
  }
}
