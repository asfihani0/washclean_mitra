import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washclean_mitra/auth/register.dart';
import 'package:washclean_mitra/pengaturan/pengaturan_screen.dart';
import 'package:washclean_mitra/pesanan/pesanan.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String? initialMitraStatus;
  final String? mitraName;

  const HomeScreen({super.key, this.initialMitraStatus, this.mitraName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _mitraStatus = 'unknown'; // Default status
  String _mitraName = 'Mitra'; // Default nama mitra

  @override
  void initState() {
    super.initState();
    _loadMitraData();
  }

  Future<void> _loadMitraData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    // Gunakan initialMitraStatus jika ada (dari login langsung)
    // Atau ambil dari SharedPreferences jika aplikasi dibuka kembali
    setState(() {
      _mitraStatus =
          widget.initialMitraStatus ??
          prefs.getString('mitra_status') ??
          'unknown';
      _mitraName = widget.mitraName ?? prefs.getString('mitra_nama') ?? 'Mitra';
    });

    // Opsional: Untuk kasus di mana status bisa berubah di backend tanpa login ulang,
    // kamu bisa panggil API untuk refresh status di sini.
    // Contoh:
    // final refreshedStatus = await ApiService.getMitraStatus(mitraId);
    // if (refreshedStatus != null && refreshedStatus != _mitraStatus) {
    //   setState(() {
    //     _mitraStatus = refreshedStatus;
    //     prefs.setString('mitra_status', refreshedStatus);
    //   });
    // }
  }

  final List<Widget> _pages = const [
    BerandaContent(),
    PesananScreen(),
    PengaturanScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Konten utama HomeScreen
          _pages[_selectedIndex],

          // Overlay jika status "Menunggu" atau "Ditolak"
          if (_mitraStatus == 'Menunggu' || _mitraStatus == 'Ditolak')
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: _mitraStatus == 'Menunggu'
                      ? _buildPendingOverlay()
                      : _buildRejectedOverlay(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 20),
        Text(
          'Halo $_mitraName, akun Anda sedang menunggu verifikasi admin.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Harap tunggu. Anda akan diberitahu setelah akun Anda aktif.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            // Coba refresh status dari SharedPreferences atau API
            await _loadMitraData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mencoba memuat ulang status...')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Periksa Status',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRejectedOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 60),
        const SizedBox(height: 20),
        Text(
          'Mohon Maaf, $_mitraName,',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Akun Anda ditolak oleh admin. Anda perlu mendaftar ulang.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            debugPrint("Logout ditekan");

            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            await prefs.remove('mitraId');
            await prefs.remove('mitra_nama');
            await prefs.remove('mitra_email');
            await prefs.remove('mitra_status');

            debugPrint("Token dan data mitra dihapus");

            if (context.mounted) {
              debugPrint("Navigasi ke RegisterMitraScreen");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterMitraScreen(),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Daftar Ulang',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class BerandaContent extends StatefulWidget {
  const BerandaContent({super.key});

  @override
  State<BerandaContent> createState() => _BerandaContentState();
}

class _BerandaContentState extends State<BerandaContent> {
  String _mitraName = 'Mitra';

  @override
  void initState() {
    super.initState();
    _loadMitraName();
  }

  Future<void> _loadMitraName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mitraName = prefs.getString('mitra_nama') ?? 'Mitra';
    });
  }

  void _openWhatsApp() async {
    const whatsappNumber = '6285748128727';
    final message = Uri.encodeComponent(
      "Halo Admin, saya ingin menanyakan status verifikasi akun saya.",
    );
    final url = 'https://wa.me/$whatsappNumber?text=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER: Background doodle + Logo W + Teks WashClean =====
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/doddle_bg.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromRGBO(33, 150, 243, 1),
                        radius: 24,
                        child: Text(
                          "W",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WashClean Mitra",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Selamat datang, $_mitraName!",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Card User Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6F95D8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hai, Asfihani Arrohman", // Ini mungkin perlu diubah dinamis juga
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Jln. Bareng Kulon VI no. 896 RT 02 RW 04, Bareng, Klojen, Malang", // Ini juga dinamis
                      style: TextStyle(color: Colors.white),
                    ),
                    Divider(color: Colors.white),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatusCount(label: "Pesanan", count: "0"),
                        _StatusCount(label: "Proses", count: "0"),
                        _StatusCount(label: "Selesai", count: "0"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Fitur utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _FeatureIcon(
                    icon: Icons.storefront,
                    label: "Cari\nOutlet",
                    onTap: () => Navigator.pushNamed(context, '/cari_outlet'),
                  ),
                  // _FeatureIcon(
                  //   icon: Icons.local_laundry_service,
                  //   label: "Layanan\nWashClean",
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       shape: const RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.vertical(
                  //           top: Radius.circular(30),
                  //         ),
                  //       ),
                  //       isScrollControlled: true,
                  //       builder: (_) => const LayananScreen(),
                  //     );
                  //   },
                  // ),
                  _FeatureIcon(
                    icon: Icons.search,
                    label: "Cari\nPesanan",
                    onTap: () => Navigator.pushNamed(context, '/pesanan'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // WhatsApp Contact Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: _openWhatsApp,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Kesulitan Saat Mengakses WashClean?\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "Hubungi Admin Kami Melalui WhatsApp!",
                              ),
                            ],
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatusCount extends StatelessWidget {
  final String label;
  final String count;

  const _StatusCount({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _FeatureIcon({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
