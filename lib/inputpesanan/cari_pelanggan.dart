import 'package:flutter/material.dart';
import 'package:washclean_mitra/inputpesanan/pilih_kategori.dart';
import 'package:washclean_mitra/services/api_services.dart';

class CariPelangganScreen extends StatefulWidget {
  const CariPelangganScreen({super.key});

  @override
  State<CariPelangganScreen> createState() => _CariPelangganScreenState();
}

class _CariPelangganScreenState extends State<CariPelangganScreen> {
  final TextEditingController _telpController = TextEditingController();
  Map<String, dynamic>? _pelanggan;
  bool _loading = false;
  String? _error;

  void _cariPelanggan() async {
    setState(() {
      _loading = true;
      _error = null;
      _pelanggan = null;
    });

    final result = await ApiService.cariPelangganByTelp(_telpController.text);

    setState(() {
      _loading = false;
      if (result != null) {
        _pelanggan = result;
      } else {
        _error = 'Pelanggan tidak ditemukan';
      }
    });
  }

  void _lanjut() {
    if (_pelanggan != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PilihKategoriScreen(pelanggan: _pelanggan!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Pelanggan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _telpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _cariPelanggan,
              child: _loading ? const CircularProgressIndicator() : const Text('Cari'),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_pelanggan != null)
              Card(
                child: ListTile(
                  title: Text(_pelanggan!['nama_pelanggan'] ?? '-'),
                  subtitle: Text(_pelanggan!['alamat'] ?? ''),
                  trailing: ElevatedButton(
                    onPressed: _lanjut,
                    child: const Text('Lanjut'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
