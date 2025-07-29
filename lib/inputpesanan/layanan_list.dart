// halaman layanan berdasarkan kategori
import 'package:flutter/material.dart';

class LayananListScreen extends StatefulWidget {
  final String kategori;
  final Map<String, dynamic> pelanggan;

  const LayananListScreen({super.key, required this.kategori, required this.pelanggan});

  @override
  State<LayananListScreen> createState() => _LayananListScreenState();
}

class _LayananListScreenState extends State<LayananListScreen> {
  List<Map<String, dynamic>> layananList = [
    {"nama": "Cuci Kering", "harga": 10000},
    {"nama": "Setrika", "harga": 8000},
    {"nama": "Cuci Sepatu", "harga": 20000},
  ];

  final Map<String, int> jumlahLayanan = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layanan ${widget.kategori}')),
      body: ListView.builder(
        itemCount: layananList.length,
        itemBuilder: (context, index) {
          final layanan = layananList[index];
          return ListTile(
            title: Text(layanan['nama']),
            subtitle: Text('Rp ${layanan['harga']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      jumlahLayanan[layanan['nama']] = (jumlahLayanan[layanan['nama']] ?? 0) - 1;
                      if (jumlahLayanan[layanan['nama']]! <= 0) {
                        jumlahLayanan.remove(layanan['nama']);
                      }
                    });
                  },
                ),
                Text('${jumlahLayanan[layanan['nama']] ?? 0}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      jumlahLayanan[layanan['nama']] = (jumlahLayanan[layanan['nama']] ?? 0) + 1;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // lanjutkan ke checkout atau simpan pesanan
          print('Pesanan untuk ${widget.pelanggan['nama']}: $jumlahLayanan');
        },
        child: const Text("Lanjutkan"),
      ),
    );
  }
}
