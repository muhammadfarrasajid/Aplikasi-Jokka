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
      // NAVBAR DIHAPUS TOTAL DARI SINI
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Header Baru (Back - Logo - Kosong)
                const _SimpleHeader(),

                const SizedBox(height: 24),

                // Judul Halaman
                const Text(
                  "Terfavorit",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 24),

                // Bagian Top 3 (Horizontal Row)
                Row(
                  children: [
                    Expanded(child: _TopRankCard(data: topThree[0])),
                    const SizedBox(width: 12),
                    Expanded(child: _TopRankCard(data: topThree[1])),
                    const SizedBox(width: 12),
                    Expanded(child: _TopRankCard(data: topThree[2])),
                  ],
                ),

                const SizedBox(height: 30),

                // List Restoran Favorit Lainnya
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
        // 1. KIRI: Tombol Back (Warna Hitam karena background putih)
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Abu-abu sangat muda
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          ),
        ),
        
        // 2. TENGAH: LOGO JOKKA GAMBAR
        Image.asset(
          'assets/images/logo_jokka.png',
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
              // Cadangan jika gambar gagal load
              return const Text("JOKKA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24));
          },
        ),
        
        // 3. KANAN: KOTAK KOSONG (Dummy)
        // Agar Logo tetap di tengah (Simetris)
        const SizedBox(width: 42, height: 42),
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
      height: 140, 
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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

// Widget untuk List ke bawah
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
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(width: 16),
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