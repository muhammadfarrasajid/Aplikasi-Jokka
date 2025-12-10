// Lokasi: lib/features/articles/presentation/articles_page.dart

import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

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
                "JokkaPedia",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Custom Grid Layout (Masonry Style Manual)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- KOLOM KIRI ---
                  Expanded(
                    child: Column(
                      children: [
                        _buildArticleCard(height: 140), // Kotak Kecil Atas
                        const SizedBox(height: 16),
                        _buildArticleCard(height: 240), // Kotak Tinggi Bawah
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16), // Jarak Tengah

                  // --- KOLOM KANAN ---
                  Expanded(
                    child: Column(
                      children: [
                        _buildArticleCard(height: 140), // Kotak Kecil Atas (Lebar)
                        const SizedBox(height: 16),
                        
                        // Nested Row untuk kotak kecil-kecil
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildArticleCard(height: 240)), // Kotak Tinggi
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildArticleCard(height: 112),
                                  const SizedBox(height: 16),
                                  _buildArticleCard(height: 112),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 4. Kotak Besar Panjang di Bawah Grid
              _buildArticleCard(height: 180, width: double.infinity),

              const SizedBox(height: 30),

              // 5. Card Artikel Detail (Putih dengan Border & Shadow Halus)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Gambar Kecil
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Teks
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ini Judul",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur...",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.bookmark_border, size: 28),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      
      // 6. Bottom Navigation Bar (Visual Only - Konsisten)
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            ),
            const Icon(Icons.explore_outlined, color: Colors.white, size: 30),
            // Icon Dokumen (Artikel) - Filled karena aktif
            const Icon(Icons.description, color: Colors.white, size: 30), 
            const Icon(Icons.bookmark_border, color: Colors.white, size: 30),
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
        const Icon(Icons.person_outline, color: Colors.black, size: 28),
      ],
    );
  }

  // Widget Kotak Placeholder Abu-abu
  Widget _buildArticleCard({required double height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}