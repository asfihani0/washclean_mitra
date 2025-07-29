// Ini adalah base class abstract, tidak bisa diinstansiasi langsung
abstract class AuthState {
  const AuthState();
}

// State Awal: saat halaman baru dibuka
class AuthInitial extends AuthState {
  const AuthInitial();
}

// State Loading: saat tombol login ditekan dan sedang menunggu respons API
class AuthLoading extends AuthState {
  const AuthLoading();
}

// State Sukses: saat login berhasil, membawa data user
class AuthSuccess extends AuthState {
  final String message; // Pesan sukses dari API
  const AuthSuccess(this.message);
}

// State Gagal: saat login gagal, membawa pesan error
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}