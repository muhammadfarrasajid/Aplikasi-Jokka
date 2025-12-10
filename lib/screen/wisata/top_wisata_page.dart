import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../detail/detail_place_page.dart';

class TopWisataPage extends StatelessWidget {
  const TopWisataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'wisata').orderBy('rating', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState(context);

            final docs = snapshot.data!.docs;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  const Text("Top Wisata Makassar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220, 
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length > 5 ? 5 : docs.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        var doc = docs[index];
                        var data = doc.data() as Map<String, dynamic>;
                        var id = doc.id; // AMBIL ID
                        return _TopRankHorizontalCard(data: data, id: id, rank: (index + 1).toString()); // KIRIM ID
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Rekomendasi Lainnya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      var id = doc.id; // AMBIL ID
                      return _WisataListCard(data: data, id: id, rank: "Top ${index + 1}"); // KIRIM ID
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(children: [const SizedBox(height: 20), Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _buildHeader(context)), Expanded(child: Center(child: Text("Belum ada data wisata", style: TextStyle(color: Colors.grey[600]))))]);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)), child: const Icon(Icons.arrow_back, color: Colors.black, size: 24))), Image.asset('assets/images/logo_jokka.png', height: 36, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Text("JOKKA", style: TextStyle(fontWeight: FontWeight.bold))), const SizedBox(width: 42, height: 42)]);
  }
}

class _TopRankHorizontalCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id; // TERIMA ID
  final String rank;

  const _TopRankHorizontalCard({required this.data, required this.id, required this.rank});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPlacePage(placeData: data, placeId: id))), // KIRIM ID
      child: Container(
        width: 160, padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Stack(children: [
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover))),
                  Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle), child: Text(rank, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))))
            ])),
            const SizedBox(height: 10),
            Text(data['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(children: [const Icon(Icons.star, size: 12, color: Colors.orange), Text(" ${data['rating'] ?? 0}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))])
        ]),
      ),
    );
  }
}

class _WisataListCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id; // TERIMA ID
  final String rank;

  const _WisataListCard({required this.data, required this.id, required this.rank});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPlacePage(placeData: data, placeId: id))), // KIRIM ID
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)), child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black54))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.black12, width: 0.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 3))]),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(data['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(data['description'] ?? 'Tidak ada deskripsi', style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(data['location'] ?? '-', style: TextStyle(fontSize: 10, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(data['price'] ?? 'Gratis', style: const TextStyle(color: JokkaColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ]),
                ])),
            ]),
          ),
      ]),
    );
  }
}