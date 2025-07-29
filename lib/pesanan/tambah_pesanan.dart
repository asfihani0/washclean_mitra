import 'package:flutter/material.dart';

class TambahPesananScreen extends StatefulWidget {
  const TambahPesananScreen({super.key});

  @override
  State<TambahPesananScreen> createState() => _TambahPesananScreenState();
}

class _TambahPesananScreenState extends State<TambahPesananScreen> {
  String? _selectedDurasi;
  final List<String> _durasiOptions = ['Reguler (3 Hari)', 'Express (1 Hari)'];

  final TextEditingController _catatanController = TextEditingController();

  void _submitPesanan(Map pelanggan) {
    if (_selectedDurasi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih durasi layanan terlebih dahulu!')),
      );
      return;
    }

    // Kirim pesanan ke backend di sini (gunakan ApiService)
    print('Pesanan dibuat untuk:');
    print('Nama: ${pelanggan['nama']}');
    print('Telepon: ${pelanggan['telepon']}');
    print('Durasi: $_selectedDurasi');
    print('Catatan: ${_catatanController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesanan berhasil dibuat!')),
    );

    Navigator.pop(context); // Kembali setelah submit
  }

  @override
  Widget build(BuildContext context) {
    final Map pelanggan = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: const Text('Input Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${pelanggan['nama']}'),
            Text('No. Telepon: ${pelanggan['telepon']}'),
            const SizedBox(height: 20),

            // Dropdown Durasi
            DropdownButtonFormField<String>(
              value: _selectedDurasi,
              decoration: const InputDecoration(
                labelText: 'Durasi Layanan',
                border: OutlineInputBorder(),
              ),
              items: _durasiOptions.map((durasi) {
                return DropdownMenuItem(
                  value: durasi,
                  child: Text(durasi),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDurasi = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Catatan Opsional
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Tombol Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitPesanan(pelanggan),
                child: const Text('Buat Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
