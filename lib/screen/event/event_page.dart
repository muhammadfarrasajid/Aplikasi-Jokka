import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_theme.dart';
import '../detail/detail_place_page.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black, 
          fontWeight: FontWeight.bold, 
          fontSize: 20
        ),
        title: const Text('Event Jokka'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // FILTER: Hanya ambil kategori 'event'
        // ORDER: Dari yang paling baru dibuat
        stream: FirebaseFirestore.instance
            .collection('places')
            .where('category', isEqualTo: 'event')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Data Kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("Belum ada event saat ini.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // 3. List Data Asli
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              var id = doc.id; // Ambil ID Dokumen

              return _RealEventCard(data: data, id: id);
            },
          );
        },
      ),
    );
  }
}

class _RealEventCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id;

  const _RealEventCard({required this.data, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Detail Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPlacePage(placeData: data, placeId: id),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // GAMBAR KIRI
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  data['imageUrl'] ?? 'https://picsum.photos/200',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // INFO KANAN
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // JUDUL EVENT
                    Text(
                      data['name'] ?? 'Nama Event',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    
                    // BARIS 1: HARGA (Gantikan Tanggal)
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined, size: 14, color: JokkaColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data['price'] ?? 'Gratis',
                            style: const TextStyle(
                              fontSize: 12,
                              color: JokkaColors.primary, 
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // BARIS 2: LOKASI
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data['location'] ?? 'Lokasi tidak ada',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}