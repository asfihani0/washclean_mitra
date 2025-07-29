class DataPesanan {
  final int id;
  final String? tanggal;

  final String? namaPelanggan;
  final String? alamatPelanggan;
  final String? noHpPelanggan;

  final String? namaMitra;
  final String? alamatMitra;
  final String? noHpMitra;

  final String? namaLayanan;
  final String? kategoriLayanan;
  final String? hargaLayanan;
  final int? berat;
  final int? durasiJam;
  final String? totalPembayaran;
  final String? statusPesanan;
  final String? statusPembayaran;
  final String? kecamatan;
  final String? kota;
  final String? provinsi;
  final String? kodePos;

  DataPesanan({
    required this.id,
    this.tanggal,
    this.namaPelanggan,
    this.alamatPelanggan,
    this.noHpPelanggan,
    this.namaMitra,
    this.alamatMitra,
    this.noHpMitra,
    this.namaLayanan,
    this.kategoriLayanan,
    this.hargaLayanan,
    this.berat,
    this.durasiJam,
    this.totalPembayaran,
    this.statusPesanan,
    this.statusPembayaran,
    this.kecamatan,
    this.kota,
    this.provinsi,
    this.kodePos,
  });



  factory DataPesanan.fromJson(Map<String, dynamic> json) {
    final pelanggan = json['pelanggan'] ?? {};
    final mitra = json['mitra'] ?? {};
    final layanan = json['layanan'] ?? {};

    return DataPesanan(
      id: json['id'],
      tanggal: json['tanggal'],

      // Data pelanggan
      namaPelanggan: pelanggan['nama'],
      alamatPelanggan: pelanggan['alamat'],
      noHpPelanggan: pelanggan['notelp'],

      // Data mitra
      namaMitra: mitra['nama'],
      alamatMitra: mitra['alamat'],
      noHpMitra: mitra['no_telp'],

      // Data layanan
      namaLayanan: layanan['nama'],
      kategoriLayanan: layanan['kategori'],
      hargaLayanan: layanan['harga'],
      berat: layanan['berat'],
      durasiJam: layanan['durasi'],
      totalPembayaran: layanan['total_pembayaran'],
      statusPesanan: layanan['status_pesanan'],
      statusPembayaran: layanan['status_pembayaran'],
      kecamatan: pelanggan['kecamatan'],       
      kota: pelanggan['kota'],                  
      kodePos: pelanggan['kodepos'],           
    );
  }
}
