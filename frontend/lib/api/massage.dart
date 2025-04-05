import 'package:dio/dio.dart';

class MassageApiService {
  final String baseUrl;
  final Dio _dio;

  MassageApiService({required this.baseUrl})
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

  // Set Favorite Massage
  Future<Response> setFavorite(String email, int id) async {
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
}
