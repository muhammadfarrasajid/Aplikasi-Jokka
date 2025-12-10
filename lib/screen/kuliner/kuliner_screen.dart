import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_theme.dart';
import '../detail/detail_place_page.dart';
import 'terfavorit_page.dart';

class KulinerScreen extends StatelessWidget {
  const KulinerScreen({super.key});

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
              _buildHeader(context),
              
              const SizedBox(height: 24),
              const Text(
                "Kuliner", 
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900, 
                  color: Colors.black
                )
              ),
              
              const SizedBox(height: 20), 

              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TerfavoritPage())),
                child: Container(
                  height: 60, width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.star_border, size: 28, color: Color(0xFFE53935)), SizedBox(width: 10), Text("Lihat Kuliner Terfavorit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text("Rekomendasi Kuliner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 16),
              
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'kuliner').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Container(padding: const EdgeInsets.all(20), alignment: Alignment.center, child: const Text("Belum ada data kuliner."));

                  final docs = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      var id = doc.id; 
                      return _RealKulinerCard(data: data, id: id); 
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context), 
          child: Container(
            padding: const EdgeInsets.all(8), 
            decoration: BoxDecoration(
              color: Colors.grey.shade100, 
              shape: BoxShape.circle, 
              border: Border.all(color: Colors.grey.shade300)
            ), 
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 24)
          )
        ), 
      ]
    );
  }
}

class _RealKulinerCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id; 

  const _RealKulinerCard({required this.data, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPlacePage(placeData: data, placeId: id))), 
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover)))),
            Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data['name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 12, color: Colors.grey), const SizedBox(width: 4), Expanded(child: Text(data['location'] ?? '-', style: TextStyle(fontSize: 10, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(data['price'] ?? 'Gratis', style: const TextStyle(fontSize: 12, color: JokkaColors.primary, fontWeight: FontWeight.bold)),
                      Row(children: [const Icon(Icons.star, size: 12, color: Colors.orange), Text(" ${data['rating'] ?? 0.0}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))])
                  ])
            ]))
        ]),
      ),
    );
  }
}