import 'package:flutter/material.dart';

class TentangKamiScreen extends StatelessWidget {
  const TentangKamiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Informasi Legal"),
          bottom: const TabBar(
            labelColor: Color(0xFF005BAA), // Warna teks tab aktif
            unselectedLabelColor: Colors.black54, // Warna teks tab tidak aktif
            indicatorColor: Color(0xFF005BAA), // Warna garis bawah aktif
            indicatorWeight: 3.0, // Ketebalan garis bawah
            tabs: [
              Tab(text: "Syarat & Ketentuan"),
              Tab(text: "Kebijakan Privasi"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TermsContent(),
            PrivacyContent(),
          ],
        ),
      ),
    );
  }
}

class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: const Text(
        '''Dengan menggunakan aplikasi WashClean, Anda dianggap telah membaca, memahami, dan menyetujui syarat dan ketentuan berikut:

1. Pendaftaran dan Penggunaan Akun
• Pelanggan wajib mengisi data diri secara lengkap dan akurat.
• Setiap akun hanya boleh digunakan oleh pemilik sah dan tidak dapat dipindahtangankan.
• Pengguna bertanggung jawab atas keamanan akun, termasuk penggunaan oleh pihak lain.

2. Pemrosesan Pesanan
• Pesanan akan diproses oleh mitra laundry setelah konfirmasi diterima.
• Status pesanan dapat dipantau melalui aplikasi secara real-time.
• Waktu penyelesaian tergantung pada jenis layanan (Reguler, Express, atau Satuan).

3. Pembayaran
• Pembayaran dilakukan melalui metode yang tersedia di aplikasi.
• Pembayaran dianggap sah setelah dikonfirmasi oleh sistem atau mitra.
• Harga layanan sesuai dengan yang tertera di aplikasi dan tidak dapat dinegosiasikan langsung dengan mitra.

4. Kewajiban Pelanggan
• Memberikan informasi penjemputan/pengantaran yang jelas dan akurat.
• Menyerahkan pakaian dalam kondisi sesuai (tidak basah/berbau menyengat).
• Mengambil pakaian tepat waktu setelah notifikasi selesai diberikan.

5. Pembatalan dan Pengembalian
• Pembatalan hanya dapat dilakukan sebelum pesanan diproses oleh mitra.
• Pengembalian dana dilakukan jika ada kesalahan layanan yang disebabkan oleh mitra.
• Komplain harus diajukan maksimal 2×24 jam setelah pesanan diterima.

6. Batas Tanggung Jawab
• WashClean tidak bertanggung jawab atas kerusakan atau kehilangan yang disebabkan oleh force majeure atau kesalahan pelanggan.
• Kompensasi (jika ada) akan diberikan berdasarkan kebijakan layanan.

7. Perubahan Layanan dan Ketentuan
• WashClean berhak memperbarui fitur layanan, harga, dan ketentuan tanpa pemberitahuan sebelumnya.
• Perubahan akan diinformasikan melalui aplikasi atau email resmi.
''',
        style: TextStyle(fontSize: 14, height: 1.6),
      ),
    );
  }
}

class PrivacyContent extends StatelessWidget {
  const PrivacyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: const Text(
        '''Kebijakan Privasi WashClean:

1. Data yang Kami Kumpulkan:
• Nama lengkap
• Nomor telepon
• Alamat pengguna/mitra
• Lokasi (jika diperlukan)
• Riwayat transaksi dan aktivitas aplikasi

2. Bagaimana Kami Menggunakan Data Anda?
• Untuk memproses dan mencatat transaksi
• Untuk menghubungkan mitra dan pelanggan
• Untuk meningkatkan layanan dan pengalaman pengguna
• Untuk keperluan administrasi dan laporan internal

3. Keamanan Data
• Kami menggunakan sistem yang aman untuk menjaga kerahasiaan data Anda.
• Data Anda tidak akan dibagikan ke pihak ketiga tanpa izin, kecuali jika diwajibkan oleh hukum.

4. Hak Anda
• Anda dapat meminta akses, perbaikan, atau penghapusan data pribadi.
• Anda bebas keluar dari akun kapan saja melalui menu pengaturan.

5. Perubahan Kebijakan
• Kami dapat memperbarui kebijakan ini sewaktu-waktu.
• Perubahan akan diberitahukan melalui aplikasi atau email resmi.

6. Kontak
Untuk pertanyaan atau permintaan terkait data, silakan hubungi:
📧 0896976897917
''',
        style: TextStyle(fontSize: 14, height: 1.6),
      ),
    );
  }
}
