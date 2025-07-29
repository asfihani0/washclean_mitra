import 'package:flutter/material.dart';
import 'package:washclean_mitra/auth/login_screen.dart';
import 'package:washclean_mitra/auth/onboarding_screen.dart';
import 'package:washclean_mitra/auth/register.dart';
import 'package:washclean_mitra/home/home_screen.dart';
import 'package:washclean_mitra/home/splashscreen.dart';
import 'package:washclean_mitra/inputpesanan/layanan_list.dart';
import 'package:washclean_mitra/inputpesanan/pilih_kategori.dart';
import 'package:washclean_mitra/model/data_pesanan.dart';
import 'package:washclean_mitra/services/detail_pesanan.dart';
import 'package:washclean_mitra/pesanan/pesanan.dart';
import 'package:washclean_mitra/inputpesanan/cari_pelanggan.dart';
import 'package:washclean_mitra/pesanan/tambah_pesanan.dart';

void main() {
  runApp(const WashCleanApp());
}

class WashCleanApp extends StatelessWidget {
  const WashCleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WASHCLEAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      // Rute statis
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterMitraScreen(),
        '/home': (context) => const HomeScreen(),
        '/pesanan': (context) => const PesananScreen(),
        '/cari_pelanggan': (context) => const CariPelangganScreen(),
        '/tambah_pesanan': (context) => const TambahPesananScreen(),
      },

      // Rute dinamis (dengan parameter)
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/pilih-kategori':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => PilihKategoriScreen(pelanggan: args),
              );
            }
            return _errorRoute();

          case '/layanan_list':
            final args = settings.arguments;
            if (args is Map<String, dynamic> &&
                args.containsKey('kategori') &&
                args.containsKey('pelanggan')) {
              return MaterialPageRoute(
                builder: (_) => LayananListScreen(
                  kategori: args['kategori'],
                  pelanggan: args['pelanggan'],
                ),
              );
            }
            return _errorRoute();

          case '/detail_pesanan':
            final args = settings.arguments;
            if (args is DataPesanan) {
              return MaterialPageRoute(
                builder: (_) => DetailPesananScreen(detail: args),
              );
            }
            return _errorRoute();

          default:
            return null;
        }
      },
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Halaman tidak ditemukan atau parameter salah.'),
        ),
      ),
    );
  }
}
