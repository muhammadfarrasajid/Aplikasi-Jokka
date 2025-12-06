import 'package:flutter/material.dart';
import 'terdekat_page.dart'; // Pastikan file terdekat_page.dart ada di folder yang sama

// PERBAIKAN: Nama class diganti jadi KulinerScreen agar cocok dengan HomePage
class KulinerScreen extends StatelessWidget {
  const KulinerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section (Image + Search Bar)
            const _HeaderSection(),

            const SizedBox(height: 30), // Spacing after search bar overlap
            
            // 2. Filter Buttons (Terdekat & Terfavorit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TOMBOL TERDEKAT (Navigasi ke TerdekatPage)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TerdekatPage(),
                          ),
                        );
                      },
                      child: const _FilterButton(
                        icon: Icons.location_on_outlined,
                        label: "Terdekat",
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // TOMBOL TERFAVORIT
                  const Expanded(
                    child: _FilterButton(
                      icon: Icons.star_border, 
                      label: "Terfavorit"
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Kuliner di sekitarmu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4. Grid Resto Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                shrinkWrap: true, // Important inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4, // Jumlah dummy data
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Adjust ratio for card height
                ),
                itemBuilder: (context, index) {
                  return const _RestoCard();
                },
              ),
            ),
          ],
        ),
      ),
      // 5. Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // Dark color from design
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows search bar to overflow
      children: [
        // Background Image
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // GANTI DENGAN GAMBAR MAKANAN KAMU (Asset/Network)
              image: NetworkImage('https://placehold.co/600x400/png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3), // Dark overlay text readability
          ),
        ),

        // App Bar Items (Logo & Profile)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "JOKKA",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900, // Extra bold
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const Icon(Icons.person_outline, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),

        // "Kuliner" Title Overlay
        const Positioned(
          left: 20,
          top: 100,
          child: Text(
            "Kuliner",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Floating Search Bar
        Positioned(
          bottom: -25, // Moves it half down
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Lagi mau makan apa hari ini ?",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: SizedBox(width: 10), // Spacer
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Icon(icon, size: 28, color: Colors.black87),
        ],
      ),
    );
  }
}

class _RestoCard extends StatelessWidget {
  const _RestoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Placeholder color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Content positioning
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama Resto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Alamat Resto",
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}