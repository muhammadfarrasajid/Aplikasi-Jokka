// Lokasi: lib/features/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- IMPORT FILE PAGE LAIN ---
import '../../core/theme/app_theme.dart';
import '../../services/notification_service.dart';
import '../../screen/kuliner/kuliner_screen.dart';
import '../../screen/wisata/top_wisata_page.dart';
// Import Wishlist (Naik satu folder ke features, lalu masuk wishlist)
import '../wishlist/presentation/wishlist_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Untuk Bottom Navigation

  // Data Menu Kotak Mengambang
  final List<Map<String, String>> floatingMenus = [
    {'icon': 'top', 'label': 'Top Wisata'},
    {'icon': 'event', 'label': 'Event'},
    {'icon': 'kuliner', 'label': 'Kuliner'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermissionOnce();
    });
  }

  Future<void> _requestNotificationPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyRequested = prefs.getBool('notifications_permission_requested') ?? false;
    if (alreadyRequested) return;
    
    await prefs.setBool('notifications_permission_requested', true);
    await NotificationService().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JokkaColors.background,
      
      // --- BOTTOM NAVIGATION BAR (Navigasi Wishlist ada di sini) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // LOGIKA NAVIGASI MENU BAWAH
          if (index == 3) { 
            // Jika tombol ke-4 (Index 3 / Saved) ditekan -> Buka Wishlist
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistPage()),
            );
          } else {
            // Selain itu, update tampilan aktif biasa
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: JokkaColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), // Index 0
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'), // Index 1
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'), // Index 2
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'), // Index 3 (Wishlist)
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: 80),
            
            // BAGIAN 1: Pilihan Jokka
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pilihan Jokka Minggu Ini", style: headingStyle),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildChip("Wisata Populer", true),
                      _buildChip("Event", false),
                      _buildChip("Artikel", false),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => _buildVerticalCard(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // BAGIAN 2: Top 5 Destinasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("Top 5 Destinasi Gammara", style: headingStyle),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: 5,
                itemBuilder: (context, index) => _buildHorizontalCard(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // BAGIAN 3: Event Bulan Ini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("Jokka Event Pada Bulan Ini", style: headingStyle),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: 5,
                itemBuilder: (context, index) => _buildHorizontalCard(isEvent: true),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
        Container(
          height: 340,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Fort_Rotterdam_2012.jpg/1200px-Fort_Rotterdam_2012.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
        ),
        
        // Teks Header & Search
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                     "JOKKA", 
                     style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.person_outline, color: Colors.white, size: 28),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Mau Jokka\nkemana hari ini?",
                style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari pantai, coto, atau event...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Menu Kotak Mengambang (Navigasi KULINER & TOP WISATA)
        Positioned(
          bottom: -40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: floatingMenus.map((menu) {
              return GestureDetector(
                onTap: () {
                  // --- LOGIKA NAVIGASI MENU KOTAK ---
                  if (menu['label'] == 'Kuliner') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KulinerScreen()),
                    );
                  } else if (menu['label'] == 'Top Wisata') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TopWisataPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Menu ${menu['label']} segera hadir!")));
                  }
                  // ----------------------------------
                },
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        menu['label'] == 'Top Wisata' ? Icons.landscape : menu['label'] == 'Event' ? Icons.event : Icons.restaurant,
                        color: JokkaColors.primary, size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(menu['label']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? JokkaColors.primary : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildVerticalCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(image: NetworkImage('https://picsum.photos/200'), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pantai Losari", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text("Ikon kota Makassar yang wajib dikunjungi saat senja.", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalCard({bool isEvent = false}) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), image: const DecorationImage(image: NetworkImage('https://picsum.photos/201'), fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEvent ? "F8 Makassar" : "Malino Highland", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(isEvent ? "12 Okt 2025" : "Gowa, Sulsel", style: TextStyle(color: Colors.grey[500], fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}