// Lokasi: lib/features/wishlist/presentation/wishlist_page.dart

import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Variable untuk mengatur Tab yang aktif (True = Wishlist, False = Rating)
  bool isWishlistActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header & Title Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Logo & Profile)
                  _buildHeader(),
                  const SizedBox(height: 30),
                  // Judul Besar
                  const Text(
                    "Wishlist &\nRating",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Tab Switcher (Wishlist / Rating)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildTabButton("Wishlist", true),
                  const SizedBox(width: 40), // Jarak antar teks tab
                  _buildTabButton("Rating", false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. List Item (Scrollable)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                itemCount: 5, // Jumlah dummy data
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildWishlistCard();
                },
              ),
            ),
          ],
        ),
      ),
      
      // 4. Bottom Navigation Bar (Visual Saja - Agar konsisten dengan desain)
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
            // Icon Home (Inactive)
            IconButton(
              onPressed: () => Navigator.pop(context), // Kembali ke Home
              icon: const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            ),
            const Icon(Icons.explore_outlined, color: Colors.white, size: 30),
            const Icon(Icons.description_outlined, color: Colors.white, size: 30),
            // Icon Wishlist/Saved (Active - Filled)
            const Icon(Icons.bookmark, color: Colors.white, size: 30), 
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

  // Widget Tombol Tab (Teks Tebal Hitam jika aktif)
  Widget _buildTabButton(String text, bool isThisTabWishlist) {
    bool isActive = isWishlistActive == isThisTabWishlist;
    return GestureDetector(
      onTap: () {
        setState(() {
          isWishlistActive = isThisTabWishlist;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.black54, // Abu jika tidak aktif
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Item
  Widget _buildWishlistCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black54, width: 0.5), // Border tipis hitam
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Kiri (Placeholder Abu)
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
                const Text(
                  "Ini Judul",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam iaculis odio et euismod...",
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
    );
  }
}