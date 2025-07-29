import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  void _cekLogin() async {
    // Delay opsional agar splash muncul sebentar
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 103, 123, 236),
      body: Center(
        child: Image.asset(
          'assets/images/logonb.png',
          width: MediaQuery.of(context).size.width * 0.5,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
