import 'package:flutter/material.dart';

class UbahKataSandiScreen extends StatelessWidget {
  const UbahKataSandiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Kata Sandi"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InputPassword(label: "Kata Sandi Lama"),
            const SizedBox(height: 12),
            _InputPassword(label: "Kata Sandi Baru"),
            const SizedBox(height: 12),
            _InputPassword(label: "Konfirmasi Kata Sandi"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Simpan Kata Sandi"
                    , style: TextStyle(fontSize: 16, color: Colors.white) ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputPassword extends StatelessWidget {
  final String label;

  const _InputPassword({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
