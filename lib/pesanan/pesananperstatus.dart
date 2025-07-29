import 'package:flutter/material.dart';
import 'package:washclean_mitra/services/detail_pesanan.dart';
import 'package:washclean_mitra/util/currency_helper.dart';
import 'package:washclean_mitra/util/date_helper.dart';
import 'package:washclean_mitra/model/data_pesanan.dart';
import 'package:washclean_mitra/services/api_services.dart';

class PesananPerStatus extends StatefulWidget {
  final String status;

  const PesananPerStatus({super.key, required this.status});

  @override
  State<PesananPerStatus> createState() => _PesananPerStatusState();
}

class _PesananPerStatusState extends State<PesananPerStatus> {
  late Future<List<DataPesanan>> futurePesanan;

  @override
  void initState() {
    super.initState();
    futurePesanan = ApiService.getPesananByStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DataPesanan>>(
      future: futurePesanan,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Terjadi error: ${snapshot.error}'));
        }

        final data = snapshot.data;

        if (data == null || data.isEmpty) {
          return const Center(child: Text('Belum ada pesanan.'));
        }
        return ListView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = data[index];

            return GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPesananScreen(detail: item),
                    ),
                  ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Image.asset(
                        "assets/images/keranjang.png",
                        width: 50,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.namaMitra ?? '-',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tgl Masuk: ${formatTanggal(item.tanggal) ?? '-'}",
                          ),
                          Text(
                            "Tgl Selesai : ${getTanggalSelesai(item.tanggal, item.durasiJam) ?? '-'}",
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                widget.status == 'proses'
                                    ? const Color(0xFF6F95D8)
                                    : widget.status == 'diambil'
                                    ? Colors.orange
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.status.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ), // jarak kecil antar status & total
                        Text(
                          "Total: Rp ${formatRupiah(item.totalPembayaran)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
