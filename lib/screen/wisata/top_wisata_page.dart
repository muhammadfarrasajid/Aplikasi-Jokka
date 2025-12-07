// Lokasi: lib/screen/wisata/top_wisata_page.dart

import 'package:flutter/material.dart';

class TopWisataPage extends StatelessWidget {
  const TopWisataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 1. Header (Logo JOKKA & Profil)
              _buildHeader(),

              const SizedBox(height: 24),

              // 2. Judul Halaman
              const Text(
                "Top Wisata Makassar",
                style: TextStyle(
                  fontSize: 24, // Sesuaikan ukuran font
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              // 3. Horizontal Scroll (Kotak Abu-abu Besar)
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // Jumlah item horizontal
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 4. List Vertical (Top 1, Top 2, Top 3)
              // Top 1
              _buildRankItem(
                rank: "Top 1",
                title: "Pantai Losari",
                description: "Ikon kota Makassar yang wajib dikunjungi saat senja. Pemandangan sunset yang indah dan kuliner pisang epe yang khas.",
              ),
              const SizedBox(height: 20),
              
              // Top 2
              _buildRankItem(
                rank: "Top 2",
                title: "Benteng Rotterdam",
                description: "Benteng peninggalan kerajaan Gowa-Tallo yang bersejarah. Arsitektur klasik yang sangat instagramable.",
              ),
              const SizedBox(height: 20),

              // Top 3
              _buildRankItem(
                rank: "Top 3",
                title: "Masjid 99 Kubah",
                description: "Masjid unik dengan 99 kubah yang menjadi landmark baru di kawasan Center Point of Indonesia (CPI).",
              ),
              
              const SizedBox(height: 40), // Spasi bawah agar tidak mentok
            ],
          ),
        ),
      ),
      
      // 5. Bottom Navigation Bar (Visual Saja)
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home_outlined, color: Colors.white, size: 30),
            Icon(Icons.explore_outlined, color: Colors.white, size: 30),
            Icon(Icons.description_outlined, color: Colors.white, size: 30),
            Icon(Icons.bookmark_border, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo JOKKA
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.grey, 
              letterSpacing: 1.2,
            ),
            children: [
              TextSpan(text: 'J'),
              WidgetSpan(
                child: Icon(Icons.location_on, color: Color(0xFFE53935), size: 24),
                alignment: PlaceholderAlignment.middle,
              ),
              TextSpan(text: 'KKA'),
            ],
          ),
        ),
        const Icon(Icons.person_outline, color: Colors.black54, size: 28),
      ],
    );
  }

  Widget _buildRankItem({required String rank, required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge "Top X"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            rank,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        
        // Card Content
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black54, width: 0.5), // Border tipis hitam
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Kiri (Placeholder)
              Container(
                width: 100,
                height: 100,
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
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}