import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washclean_mitra/model/layanan.dart';
import 'package:washclean_mitra/model/data_pesanan.dart';

class ApiService {
  static const String baseUrl = 'https://87b42a2dc6d9.ngrok-free.app/api';

  // ========================
  /// Login Mitra
  /// Mengembalikan Map<String, dynamic> yang berisi id dan status mitra
  /// ========================
  static Future<Map<String, dynamic>?> loginMitra({
    required String email,
    required String password,
  }) async {
    final loginUrl = Uri.parse('$baseUrl/mitra/login');

    final response = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Login response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final token = data['token'];
        final id = data['user']['id']?.toString();
        final mitraStatus = data['user']['status'] as String?; // Ambil status dari respons Laravel
        final namaMitra = data['user']['nama_mitra'] as String?; // Ambil nama mitra

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('mitraId', id ?? '0');
        await prefs.setString('mitra_nama', namaMitra ?? 'Mitra'); // Simpan nama mitra
        await prefs.setString('mitra_email', data['user']['email']);
        await prefs.setString('mitra_status', mitraStatus ?? 'unknown'); // Simpan status mitra

        return {'id': id, 'status': mitraStatus, 'nama_mitra': namaMitra}; // Kembalikan ID dan Status
      } else {
        // Jika status bukan 'success' tapi statusCode 200 (misal: email/pass salah)
        return null; // Atau kembalikan Map dengan pesan error jika diperlukan
      }
    } else {
      // Tangani status code selain 200 (misal: 401 Unauthorized)
      final errorData = jsonDecode(response.body);
      print('Login Error: ${errorData['message']}');
      return null;
    }
  }

  // ========================
  /// Register Mitra (dengan upload gambar)
  /// ========================
  static Future<Map<String, dynamic>?> registerMitra({
    required String namaPemilik,
    required String namaMitra,
    required String noTelp,
    required String email,
    required String password,
    required String alamat,
    required String kecamatan,
    required String kota,
    required String provinsi,
    required String kodepos,
    required File fotoKtp,
    required File fotoDepan,
    required File fotoDalam,
    required File buktiPembayaran,
  }) async {
    final registerUrl = Uri.parse('$baseUrl/mitra/register');
    var request = http.MultipartRequest('POST', registerUrl);

    // Tambahkan semua field teks
    request.fields['nama_pemilik'] = namaPemilik;
    request.fields['nama_mitra'] = namaMitra;
    request.fields['no_telp'] = noTelp;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['alamat'] = alamat;
    request.fields['kecamatan'] = kecamatan;
    request.fields['kota'] = kota;
    request.fields['provinsi'] = provinsi;
    request.fields['kodepos'] = kodepos;

    // Tambahkan file gambar
    try {
      request.files.add(await http.MultipartFile.fromPath('foto_ktp', fotoKtp.path));
      request.files.add(await http.MultipartFile.fromPath('foto_depan', fotoDepan.path));
      request.files.add(await http.MultipartFile.fromPath('foto_dalam', fotoDalam.path));
      request.files.add(await http.MultipartFile.fromPath('bukti_pembayaran', buktiPembayaran.path));
    } catch (e) {
      print('Error adding files to request: $e');
      return {'status': 'error', 'message': 'Failed to prepare image files.'};
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Register response status: ${response.statusCode}');
      print('Register response body: $responseBody');

      final Map<String, dynamic> data = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        return {'status': 'error', 'message': data['message'] ?? 'Terjadi kesalahan tidak dikenal.'};
      }
    } catch (e) {
      print('Error during registration API call: $e');
      return {'status': 'error', 'message': 'Koneksi gagal atau error server: $e'};
    }
  }

  // ========================
  /// Cari Pelanggan by No. Telepon
  /// ========================
  static Future<Map<String, dynamic>?> cariPelangganByTelp(String notelp) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/mitra/pelanggan/by-phone/$notelp');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Response cari pelanggan: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success' && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      }
    }

    return null;
  }
  /// ========================
  /// Ambil Semua Layanan
  /// ========================
  static Future<List<Layanan>> getAllLayanan() async {
    final url = Uri.parse('$baseUrl/layanan');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['data'] != null) {
          return (body['data'] as List)
              .map((json) => Layanan.fromJson(json))
              .toList();
        } else {
          print("Data layanan kosong.");
          return [];
        }
      } else {
        print("Gagal fetch layanan: ${response.statusCode} ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetch layanan: $e");
      return [];
    }
  }

  /// ========================
  /// Filter Layanan Berdasarkan Kategori
  /// ========================
  static Future<List<Layanan>> getLayananByKategori(String kategori) async {
    final allLayanan = await getAllLayanan();

    return allLayanan.where((layanan) {
      return layanan.kategori.toLowerCase() == kategori.toLowerCase();
    }).toList();
  }

  // ========================
  /// Ambil Pesanan Berdasarkan Status
  /// ========================
  static Future<List<DataPesanan>> getPesananByStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/pelanggan/transaksi?status_pesanan=$status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['data'] == null) {
        throw Exception('Data pesanan kosong');
      }
      final List<dynamic> data = body['data'];
      return data.map((e) => DataPesanan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pesanan');
    }
  }
}