class Layanan {
  final int id;
  final String namaLayanan;
  final String kategori;
  final int durasi;
  final String deskripsi;
  final String ketentuan;
  final String harga;

  Layanan({
    required this.id,
    required this.namaLayanan,
    required this.kategori,
    required this.durasi,
    required this.deskripsi,
    required this.ketentuan,
    required this.harga,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) {
    return Layanan(
      id: json['id'],
      namaLayanan: json['nama_layanan'],
      kategori: json['kategori'],
      durasi: json['durasi'],
      deskripsi: json['deskripsi'],
      ketentuan: json['ketentuan'],
      harga: json['harga'],
    );
  }
}
