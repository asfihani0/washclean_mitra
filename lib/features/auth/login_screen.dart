import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_screen.dart';
import 'auth_providers.dart';
import 'presentation/notifiers/auth_state.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  //test
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. LISTEN untuk aksi (SnackBar, Navigasi)
    ref.listen<AuthState>(authControllerProvider, (previous, state) {
      if (state is AuthSuccess) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.message)));
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      } else if (state is AuthFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
      }
    });

    // 2. WATCH untuk rebuild UI (menampilkan loading, dll)
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login Mitra')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang Kembali!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // 3. READ untuk memicu aksi
                onPressed: authState is AuthLoading
                    ? null // Tombol nonaktif saat loading
                    : () {
                        ref
                            .read(authControllerProvider.notifier)
                            .login(
                              _emailController.text,
                              _passwordController.text,
                            );
                      },
                child: authState is AuthLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('LOGIN'),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
