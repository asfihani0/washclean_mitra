import 'package:flutter/material.dart';
import 'layanan_list.dart';

class PilihKategoriScreen extends StatelessWidget {
  final Map<String, dynamic> pelanggan;
  const PilihKategoriScreen({super.key, required this.pelanggan});

  final List<String> kategoriList = const ['Reguler', 'Express', 'Satuan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kategori Layanan')),
      body: ListView.builder(
        itemCount: kategoriList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(kategoriList[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LayananListScreen(
                    kategori: kategoriList[index],
                    pelanggan: pelanggan,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
