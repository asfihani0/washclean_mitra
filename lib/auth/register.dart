import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:washclean_mitra/services/api_services.dart'; // Pastikan path ini benar!

class RegisterMitraScreen extends StatefulWidget {
  const RegisterMitraScreen({Key? key}) : super(key: key);

  @override
  State<RegisterMitraScreen> createState() => _RegisterMitraScreenState();
}

class _RegisterMitraScreenState extends State<RegisterMitraScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPemilikController = TextEditingController(); // Nama Pemilik
  final TextEditingController _namaMitraController = TextEditingController(); // Nama Mitra
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController(); // No. Telepon
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodeposController = TextEditingController();

  File? _ktpImage;
  File? _mitraDepanImage;
  File? _mitraDalamImage;
  File? _buktiBayarImage;

  bool _isLoading = false; // State untuk loading indicator

  Future<void> _pickImage(String target) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompresi gambar sedikit untuk upload lebih cepat
    );
    if (!mounted) return;

    if (pickedFile != null) {
      setState(() {
        switch (target) {
          case 'ktp':
            _ktpImage = File(pickedFile.path);
            break;
          case 'depan':
            _mitraDepanImage = File(pickedFile.path);
            break;
          case 'dalam':
            _mitraDalamImage = File(pickedFile.path);
            break;
          case 'bayar':
            _buktiBayarImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validasi apakah semua gambar sudah dipilih
      if (_ktpImage == null ||
          _mitraDepanImage == null ||
          _mitraDalamImage == null ||
          _buktiBayarImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap pilih semua gambar yang diperlukan.')),
        );
        return; // Hentikan proses jika ada gambar yang belum dipilih
      }

      setState(() {
        _isLoading = true; // Tampilkan loading indicator
      });

      try {
        final response = await ApiService.registerMitra(
          namaPemilik: _namaPemilikController.text,
          namaMitra: _namaMitraController.text, // Ambil dari controller baru
          noTelp: _noTelpController.text,
          email: _emailController.text,
          password: _passwordController.text,
          alamat: _alamatController.text,
          kecamatan: _kecamatanController.text,
          kota: _kotaController.text,
          provinsi: _provinsiController.text,
          kodepos: _kodeposController.text,
          fotoKtp: _ktpImage!,
          fotoDepan: _mitraDepanImage!,
          fotoDalam: _mitraDalamImage!,
          buktiPembayaran: _buktiBayarImage!,
        );

        if (response != null) {
          if (response['message'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );
          }
          // Logika tambahan berdasarkan respons Laravel
          if (response['status'] == 'success' || response['message'] == 'Pendaftaran berhasil. Menunggu verifikasi.' || response['message'] == 'Pendaftaran ulang berhasil. Menunggu verifikasi ulang.') {
            // Navigasi ke halaman sukses atau login
            Navigator.of(context).pop(); // Contoh: kembali ke halaman sebelumnya (login)
          } else if (response['message'] == 'Email sudah digunakan dan tidak bisa mendaftar ulang.') {
            // Email sudah digunakan dan tidak bisa daftar ulang
            // Tampilkan pesan spesifik
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan saat pendaftaran. Coba lagi.')),
          );
        }
      } catch (e) {
        print('Error calling registerMitra: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Sembunyikan loading indicator
        });
      }
    }
  }

  @override
  void dispose() {
    _namaPemilikController.dispose();
    _namaMitraController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _noTelpController.dispose();
    _alamatController.dispose();
    _kecamatanController.dispose();
    _kotaController.dispose();
    _provinsiController.dispose();
    _kodeposController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Mitra'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaPemilikController,
                      decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                      validator: (value) => value!.isEmpty ? 'Masukkan nama pemilik' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaMitraController, // Field baru: Nama Mitra
                      decoration: const InputDecoration(labelText: 'Nama Mitra'),
                      validator: (value) => value!.isEmpty ? 'Masukkan nama mitra' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noTelpController, // Field baru: No. Telepon
                      decoration: const InputDecoration(labelText: 'No. Telepon'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Masukkan nomor telepon' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty || !value.contains('@') ? 'Masukkan email valid' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => value!.length < 6 ? 'Password minimal 6 karakter' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
                      validator: (value) => value!.isEmpty ? 'Masukkan alamat' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _kecamatanController,
                      decoration: const InputDecoration(labelText: 'Kecamatan'),
                      validator: (value) => value!.isEmpty ? 'Masukkan kecamatan' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _kotaController,
                      decoration: const InputDecoration(labelText: 'Kota'),
                      validator: (value) => value!.isEmpty ? 'Masukkan kota' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _provinsiController,
                      decoration: const InputDecoration(labelText: 'Provinsi'),
                      validator: (value) => value!.isEmpty ? 'Masukkan provinsi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _kodeposController,
                      decoration: const InputDecoration(labelText: 'Kode Pos'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Masukkan kode pos' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildImagePicker('Foto KTP', _ktpImage, () => _pickImage('ktp')),
                    const SizedBox(height: 12),
                    _buildImagePicker('Foto Tampak Depan Mitra', _mitraDepanImage, () => _pickImage('depan')),
                    const SizedBox(height: 12),
                    _buildImagePicker('Foto Tampak Dalam Mitra', _mitraDalamImage, () => _pickImage('dalam')),
                    const SizedBox(height: 12),
                    _buildImagePicker('Bukti Pembayaran', _buktiBayarImage, () => _pickImage('bayar')),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Daftar Sekarang'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker(String title, File? imageFile, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageFile != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Colors.grey[400]),
                        Text('Pilih $title', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}