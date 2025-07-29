class UserModel {
  final int id;
  final String namaUsaha;
  final String email;
  final String status;
  final String token; // Kita juga simpan token di sini

  UserModel({
    required this.id,
    required this.namaUsaha,
    required this.email,
    required this.status,
    required this.token,
  });

  // Factory constructor untuk membuat UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['id'],
      namaUsaha: json['data']['nama_usaha'],
      email: json['data']['email'],
      status: json['data']['status'],
      token: json['token'], // Ambil token dari root JSON
    );
  }
}