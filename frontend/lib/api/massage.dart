import 'package:dio/dio.dart';

class MassageApiService {
  final Dio _dio;

  MassageApiService()
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
      print(response.runtimeType);
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to fetch massage: ${e.response?.data ?? e.message}');
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
          'Failed to get fav single massage: ${e.response?.data ?? e.message}');
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
          'Failed to fav single massage: ${e.response?.data ?? e.message}');
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
          'Failed to unfav single massage: ${e.response?.data ?? e.message}');
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
          'Failed to get fav set massage: ${e.response?.data ?? e.message}');
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
          'Failed to fav set massage: ${e.response?.data ?? e.message}');
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
          'Failed to unfav set massage: ${e.response?.data ?? e.message}');
    }
  }

  // Get massages by page
  Future<Response> getMassagesByPage(int page, int pageSize) async {
    try {
      final response = await _dio.get(
        '/massage/single-list',
        queryParameters: {
          'page': page,
          'pageSize': pageSize
        }
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to get massages by page: ${e.response?.data ?? e.message}');
    }
  }

  // Get set massages by page
  Future<Response> getSetMassagesByPage(int page, int pageSize) async {
    try {
      final response = await _dio.get(
        '/massage/set-list',
        queryParameters: {
          'page': page,
          'pageSize': pageSize
        }
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to get set massages by page: ${e.response?.data ?? e.message}');
    }
  }
}
