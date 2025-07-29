import 'package:flutter/material.dart';

class InputJumlahScreen extends StatefulWidget {
  final Map<String, dynamic> pelanggan;
  final Map<String, dynamic> layanan;

  const InputJumlahScreen({
    super.key,
    required this.pelanggan,
    required this.layanan,
  });

  @override
  State<InputJumlahScreen> createState() => _InputJumlahScreenState();
}

class _InputJumlahScreenState extends State<InputJumlahScreen> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Jumlah Layanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Pelanggan: ${widget.pelanggan['nama']}'),
            const SizedBox(height: 10),
            Text('Layanan: ${widget.layanan['nama']}'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Jumlah:'),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (jumlah > 1) jumlah--;
                    });
                  },
                ),
                Text('$jumlah'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      jumlah++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // simpan pesanan atau lanjutkan ke konfirmasi
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sukses'),
                    content: Text(
                      'Layanan ${widget.layanan['nama']} sebanyak $jumlah berhasil dipilih untuk ${widget.pelanggan['nama']}.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              },
              child: const Text('Simpan Pesanan'),
            )
          ],
        ),
      ),
    );
  }
}
