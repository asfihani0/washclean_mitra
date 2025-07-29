import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  final Dio _dio;

  // Constructor ini memungkinkan kita setup Dio dengan konfigurasi dasar
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

  // Fungsi untuk Login
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login', // Ini akan digabung dengan baseUrl -> .../api/mitra/login
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      // Kita lempar lagi error-nya agar bisa ditangkap oleh Repository
      throw Exception('Gagal melakukan panggilan login: ${e.message}');
    }
  }
}
