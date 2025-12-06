// Lokasi: lib/screen/kuliner/terfavorit_page.dart

import 'package:flutter/material.dart';

class TerfavoritPage extends StatelessWidget {
  const TerfavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy untuk Top 3 (Atas)
    final List<Map<String, String>> topThree = [
      {'rank': '1', 'name': 'Nama Resto', 'address': 'Alamat Resto'},
      {'rank': '2', 'name': 'Nama Resto', 'address': 'Alamat Resto'},
      {'rank': '3', 'name': 'Nama Resto', 'address': 'Alamat Resto'},
    ];

    // Data Dummy untuk List (Bawah)
    final List<Map<String, dynamic>> favoriteList = [
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
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Agar seluruh halaman bisa di-scroll
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // 1. Header (Logo JOKKA & Profil)
                const _SimpleHeader(),

                const SizedBox(height: 24),

                // 2. Judul Halaman
                const Text(
                  "Terfavorit",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Bagian Top 3 (Horizontal Row)
                Row(
                  children: [
                    // Item 1
                    Expanded(child: _TopRankCard(data: topThree[0])),
                    const SizedBox(width: 12),
                    // Item 2
                    Expanded(child: _TopRankCard(data: topThree[1])),
                    const SizedBox(width: 12),
                    // Item 3
                    Expanded(child: _TopRankCard(data: topThree[2])),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. List Restoran Favorit Lainnya
                ListView.separated(
                  shrinkWrap: true, // Agar bisa dalam SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
                  itemCount: favoriteList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _RestoListCard(data: favoriteList[index]);
                  },
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      
      // 5. Bottom Navigation Bar
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
}

// --- WIDGET COMPONENTS ---

class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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

// Widget untuk Kartu Top 3 (Kotak Abu di atas)
class _TopRankCard extends StatelessWidget {
  final Map<String, String> data;

  const _TopRankCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, // Tinggi kartu top 3
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ikon Medali / Peringkat
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Text(
              data['rank']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          // Info Text
          Column(
            children: [
              Text(
                data['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Text(
                data['address']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget untuk List ke bawah (Sama style dengan TerdekatPage)
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
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Gambar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(width: 16),
          // Info Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data['price']}\n${data['distance']}",
                  style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.directions_walk, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data['walk'],
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.pedal_bike, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      data['bike'],
                      style: const TextStyle(fontSize: 10),
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