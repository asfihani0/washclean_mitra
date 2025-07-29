import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = const AuthFailure('Email dan password tidak boleh kosong.');
      // Kembalikan ke state awal setelah pesan error
      Future.delayed(
        const Duration(milliseconds: 100),
        () => state = const AuthInitial(),
      );
      return;
    }

    state = const AuthLoading();
    try {
      final user = await _authRepository.login(email, password);
      // Di langkah selanjutnya kita akan simpan token ini
      // Contoh: await SecureStorage.saveToken(user.token);
      state = AuthSuccess('Selamat datang, ${user.namaUsaha}!');
    } catch (e) {
      state = AuthFailure(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
