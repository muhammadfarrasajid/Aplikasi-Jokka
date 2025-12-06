// Lokasi: lib/screen/kuliner/terdekat_page.dart

import 'package:flutter/material.dart';

class TerdekatPage extends StatelessWidget {
  const TerdekatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy sesuai teks pada desain gambar kamu
    final List<Map<String, dynamic>> dataResto = [
      {
        "name": "Nama Resto",
        "price": "20rb - 40rb",
        "distance": "1 Km",
        "walk": "12-15 Menit",
        "bike": "2-3 Menit",
      },
      {
        "name": "Nama Resto",
        "price": "20rb - 40rb",
        "distance": "3 Km",
        "walk": "35-45 Menit",
        "bike": "5-8 Menit",
      },
      {
        "name": "Nama Resto",
        "price": "20rb - 40rb",
        "distance": "5 Km",
        "walk": "Tidak direkomendasikan 1 jam 15 menit",
        "bike": "10-15 Menit",
      },
      {
        "name": "Nama Resto",
        "price": "20rb - 40rb",
        "distance": "7 Km",
        "walk": "Tidak direkomendasikan 1 jam 30 menit",
        "bike": "15-18 Menit",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Logo JOKKA & Profil)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: _SimpleHeader(),
            ),

            // 2. Judul Halaman "Terdekat"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Terdekat",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // Extra Bold
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. List Restoran (Scrollable)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                itemCount: dataResto.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return _RestoListCard(data: dataResto[index]);
                },
              ),
            ),
          ],
        ),
      ),
      
      // 4. Bottom Navigation (Visual Only - Konsisten dengan desain)
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // Warna hitam sesuai desain
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
}

// --- WIDGET COMPONENTS ---

class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo JOKKA (Simulasi Text & Icon agar mirip gambar)
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
}

class _RestoListCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _RestoListCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12, width: 1), // Border tipis halus
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KIRI: Placeholder Gambar (Kotak Abu)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // KANAN: Informasi Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Resto
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Harga & Jarak
                Text(
                  "${data['price']}\n${data['distance']}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.4, // Spasi antar baris
                  ),
                ),
                
                const SizedBox(height: 10),

                // Icon Jalan Kaki + Waktu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.directions_walk, size: 16, color: Colors.black87),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        data['walk'],
                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),

                // Icon Sepeda + Waktu
                Row(
                  children: [
                    // Menggunakan icon sepeda yang mirip
                    const Icon(Icons.pedal_bike, size: 16, color: Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      data['bike'],
                      style: const TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}