import 'package:flutter/material.dart';
import 'package:washclean_mitra/model/data_pesanan.dart';
import 'package:washclean_mitra/util/currency_helper.dart';
import 'package:washclean_mitra/util/date_helper.dart';

class DetailPesananScreen extends StatelessWidget {
  final DataPesanan detail;

  const DetailPesananScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Anda'),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Laundry
            Row(
              children: [
                const Icon(Icons.store, size: 20),
                const SizedBox(width: 8),
                Text(
                  detail.namaMitra ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Data Pelanggan (Tanpa Alamat & No HP karena tidak ada di model)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profil.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.namaPelanggan ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${detail.alamatPelanggan ?? '-'}, "
                        "${detail.kecamatan ?? '-'}, "
                        "${detail.kota ?? '-'}, "
                        "${detail.kodePos ?? '-'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 2),
                      Text(
                        detail.noHpPelanggan ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.download, size: 24),
              ],
            ),

            const SizedBox(height: 20),

            // Box Jenis Layanan
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nama Layanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(detail.namaLayanan ?? '-'),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Berat',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${detail.berat ?? '-'} Kg'),
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Harga Layanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Rp ${formatRupiah(detail.hargaLayanan)}'),
                    ],
                  ),

                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Rp ${formatRupiah(detail.totalPembayaran)}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informasi Detail
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildRow('Dibuat oleh', detail.namaMitra),
                  _buildRow('Status Pesanan', detail.statusPesanan),
                  _buildRow(
                    'Tanggal Masuk',
                    formatTanggal(detail.tanggal) ?? '-',
                  ),
                  _buildRow(
                    'Estimasi Selesai',
                    getTanggalSelesai(
                          detail.tanggal,
                          detail.durasiJam,
                        )?.substring(0, 10) ??
                        '-',
                  ),
                  _buildRow('Status Pembayaran', detail.statusPembayaran),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Catatan
            const Text(
              'Catatan : Silakan periksa status pesanan Anda secara berkala untuk memastikan proses layanan berjalan dengan lancar.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
