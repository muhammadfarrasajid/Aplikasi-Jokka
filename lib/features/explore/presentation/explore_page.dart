// Lokasi: lib/features/explore/presentation/explore_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan import ini sesuai dengan struktur project Anda
import '../../../providers/user_provider.dart';
import '../../../screen/admin/add_place_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user provider untuk logika icon profil di header
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // --- HEADER (TIDAK DIUBAH) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_jokka_header.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                "JOKKA",
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: userProvider.isAdmin
                ? GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPlacePage(),
                      ),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 32,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Halaman Profil sedang dikerjakan teman!",
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
          ),
        ],
      ),

      // --- BODY BARU (SESUAI REFERENSI GAMBAR 1) ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // 1. Teks Judul
              const Text(
                "Temukan ratusan destinasi,\nevent seru, dan kuliner otentik di\nMakassar bersama Jokka.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800, // Bold tebal
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // 2. Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari pantai, coto, atau event musik...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Sudut bulat
                    borderSide: BorderSide.none, // Hilangkan garis border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Baris Kategori 1 (Kotak Persegi)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryPlaceholder(width: 80, height: 80),
                    const SizedBox(width: 12),
                    _buildCategoryPlaceholder(width: 80, height: 80),
                    const SizedBox(width: 12),
                    _buildCategoryPlaceholder(width: 80, height: 80),
                    const SizedBox(width: 12),
                    _buildCategoryPlaceholder(width: 80, height: 80),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Baris Kategori 2 (Kotak Persegi Panjang Lebar)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryPlaceholder(width: 140, height: 80),
                    const SizedBox(width: 12),
                    _buildCategoryPlaceholder(width: 140, height: 80),
                    const SizedBox(width: 12),
                    _buildCategoryPlaceholder(width: 140, height: 80),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 5. Daftar List Card (Vertikal)
              // Menggunakan ListView.separated di dalam SingleChildScrollView
              ListView.separated(
                shrinkWrap: true, // Agar tidak konflik scroll
                physics:
                    const NeverScrollableScrollPhysics(), // Matikan scroll internal
                itemCount: 3, // Contoh 3 item dummy
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildExploreListCard();
                },
              ),

              // Jarak tambahan di bawah agar tidak tertutup navbar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Widget Placeholder untuk Kategori (Kotak abu-abu)
  Widget _buildCategoryPlaceholder({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // Widget Card untuk List item (Mirip style wishlist)
  Widget _buildExploreListCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Gambar Kiri
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 16),

          // Teks Kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                const Text(
                  "Ini Judul",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam iaculis odio et euismod placerat...",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
