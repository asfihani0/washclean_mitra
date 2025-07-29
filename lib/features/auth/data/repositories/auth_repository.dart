import '../models/user_model.dart';
import '../../../../api/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        // Ini untuk menangani kasus jika status code bukan 200
        throw Exception(response.data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      // Melempar kembali error yang sudah diformat dari ApiService
      rethrow;
    }
  }
}