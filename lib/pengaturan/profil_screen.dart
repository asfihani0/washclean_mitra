import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profil
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profil.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Asfihani Arrohman',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jl. Bareng Kulon VI no. 896 RT 02 RW 04,\nBareng, Klojen, Malang',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),

            // List menu
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Pengaturan12Akun'),
              subtitle: const Text('Ubah Profil Anda'),
              onTap: () {
                Navigator.pushNamed(context, '/edit_profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key),
              title: const Text('Pengaturan Kata Sandi'),
              subtitle: const Text('Ubah Kata Sandi Anda'),
              onTap: () {
                Navigator.pushNamed(context, '/ubah_password');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Kami'),
              subtitle: const Text(
                'Profil, Syarat Ketentuan, & Kebijakan Privasi',
              ),
              onTap: () {
                Navigator.pushNamed(context, '/tentang_kami');
              },
            ),

            const Divider(),
            const SizedBox(height: 16),

            // Tombol Logout
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tambahkan logika logout di sini
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('r Akun'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F95D8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
