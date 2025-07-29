import 'dart:io'; // Penting untuk tipe File

class DataRegister {
  final String namaPemilik;
  final String namaMitra; // Tambahkan ini, karena ada di Laravel validation
  final String noTelp;
  final String email;
  final String password;
  final String alamat;
  final String kecamatan;
  final String kota;
  final String provinsi;
  final String kodepos;
  final File? fotoKtp;
  final File? fotoDepan;
  final File? fotoDalam;
  final File? buktiPembayaran;
  final String? status; // Opsional, dari respons API
  final String? alasanPenolakan; // Opsional, dari respons API

  DataRegister({
    required this.namaPemilik,
    required this.namaMitra,
    required this.noTelp,
    required this.email,
    required this.password,
    required this.alamat,
    required this.kecamatan,
    required this.kota,
    required this.provinsi,
    required this.kodepos,
    this.fotoKtp,
    this.fotoDepan,
    this.fotoDalam,
    this.buktiPembayaran,
    this.status,
    this.alasanPenolakan,
  });

  // Factory constructor untuk membuat objek dari JSON (respons API)
  factory DataRegister.fromJson(Map<String, dynamic> json) {
    return DataRegister(
      namaPemilik: json['nama_pemilik'] as String,
      namaMitra: json['nama_mitra'] as String,
      noTelp: json['no_telp'] as String,
      email: json['email'] as String,
      password: '', // Password tidak seharusnya diambil kembali dari API
      alamat: json['alamat'] as String,
      kecamatan: json['kecamatan'] as String,
      kota: json['kota'] as String,
      provinsi: json['provinsi'] as String,
      kodepos: json['kodepos'] as String,
      // Untuk gambar, kita hanya menyimpan path/URL jika API mengembalikannya
      // Jika tidak, biarkan null atau sesuaikan dengan struktur responsmu
      // fotoKtp: json['foto_ktp'] as String?, // Contoh jika API mengembalikan URL gambar
      // fotoDepan: json['foto_depan'] as String?,
      // fotoDalam: json['foto_dalam'] as String?,
      // buktiPembayaran: json['bukti_pembayaran'] as String?,
      status: json['status'] as String?,
      alasanPenolakan: json['alasan_penolakan'] as String?,
    );
  }

  // Method untuk mengubah objek menjadi Map (untuk data teks, tidak termasuk file)
  Map<String, String> toMap() {
    return {
      'nama_pemilik': namaPemilik,
      'nama_mitra': namaMitra,
      'no_telp': noTelp,
      'email': email,
      'password': password,
      'alamat': alamat,
      'kecamatan': kecamatan,
      'kota': kota,
      'provinsi': provinsi,
      'kodepos': kodepos,
    };
  }
}