import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/notifiers/auth_controller.dart';
import 'presentation/notifiers/auth_state.dart';

// Provider untuk AuthRepository. Kita hanya membuat instance-nya.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Provider untuk AuthController.
// Ia butuh AuthRepository, jadi kita 'read' dari provider sebelumnya.
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository);
});