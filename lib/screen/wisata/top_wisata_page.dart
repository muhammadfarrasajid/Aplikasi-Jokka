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
              
              // 1. Header (Back - Logo - Kosong)
              _buildHeader(context),

              const SizedBox(height: 24),

              // 2. Judul Halaman
              const Text(
                "Top Wisata Makassar",
                style: TextStyle(
                  fontSize: 24,
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
                  itemCount: 4,
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
              _buildRankItem(
                rank: "Top 1",
                title: "Pantai Losari",
                description: "Ikon kota Makassar yang wajib dikunjungi saat senja. Pemandangan sunset yang indah dan kuliner pisang epe yang khas.",
              ),
              const SizedBox(height: 20),
              
              _buildRankItem(
                rank: "Top 2",
                title: "Benteng Rotterdam",
                description: "Benteng peninggalan kerajaan Gowa-Tallo yang bersejarah. Arsitektur klasik yang sangat instagramable.",
              ),
              const SizedBox(height: 20),

              _buildRankItem(
                rank: "Top 3",
                title: "Masjid 99 Kubah",
                description: "Masjid unik dengan 99 kubah yang menjadi landmark baru di kawasan Center Point of Indonesia (CPI).",
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. KIRI: Tombol Back (Seperti di Kuliner)
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          ),
        ),

        // 2. TENGAH: Logo Jokka PNG
        Image.asset(
          'assets/images/logo_jokka.png',
          height: 36,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
              return const Text("JOKKA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24));
          },
        ),

        // 3. KANAN: Kotak Kosong (Dummy)
        const SizedBox(width: 42, height: 42),
      ],
    );
  }

  Widget _buildRankItem({required String rank, required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black54, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 16),

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