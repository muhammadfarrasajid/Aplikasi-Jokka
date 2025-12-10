import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../detail/detail_place_page.dart';

class TerfavoritPage extends StatelessWidget {
  const TerfavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'kuliner').orderBy('rating', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState(context);

            final docs = snapshot.data!.docs;

            var top1Doc = docs.isNotEmpty ? docs[0] : null;
            var top2Doc = docs.length > 1 ? docs[1] : null;
            var top3Doc = docs.length > 2 ? docs[2] : null;

            var restList = docs.length > 3 ? docs.sublist(3) : [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const _SimpleHeader(),
                    const SizedBox(height: 24),
                    const Text("Terfavorit", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black)),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _TopRankCard(rank: '2', doc: top2Doc)), // PASS DOC
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: _TopRankCard(rank: '1', doc: top1Doc, isWinner: true)), // PASS DOC
                        const SizedBox(width: 12),
                        Expanded(child: _TopRankCard(rank: '3', doc: top3Doc)), // PASS DOC
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (restList.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: restList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                           return _RestoListCard(doc: restList[index]); // PASS DOC
                        },
                      )
                    else if (docs.length <= 3)
                       const Padding(padding: EdgeInsets.only(top: 20), child: Center(child: Text("Belum ada data favorit lainnya.", style: TextStyle(color: Colors.grey)))),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(children: [const SizedBox(height: 20), const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: _SimpleHeader()), Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.star_border, size: 80, color: Colors.grey[300]), const SizedBox(height: 10), const Text("Belum ada data favorit", style: TextStyle(color: Colors.grey))]))),]);
  }
}

class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)), child: const Icon(Icons.arrow_back, color: Colors.black, size: 24))), Image.asset('assets/images/logo_jokka.png', height: 32, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Text("JOKKA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24))), const SizedBox(width: 42, height: 42)]);
  }
}

class _TopRankCard extends StatelessWidget {
  final String rank;
  final DocumentSnapshot? doc; // GANTI DATA JADI DOC
  final bool isWinner;

  const _TopRankCard({required this.rank, this.doc, this.isWinner = false});

  @override
  Widget build(BuildContext context) {
    if (doc == null) return SizedBox(height: isWinner ? 180 : 140);
    
    var data = doc!.data() as Map<String, dynamic>;
    var id = doc!.id; // AMBIL ID

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPlacePage(placeData: data, placeId: id))), // KIRIM ID
      child: Container(
        height: isWinner ? 190 : 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isWinner ? Colors.amber[50] : Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: isWinner ? Colors.amber : Colors.grey.shade300)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: isWinner ? 60 : 45, height: isWinner ? 60 : 45, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))], image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover))),
            const SizedBox(height: 8),
            Container(padding: EdgeInsets.all(isWinner ? 8 : 6), decoration: BoxDecoration(shape: BoxShape.circle, color: isWinner ? Colors.amber : Colors.white, border: Border.all(color: Colors.black, width: 1.5)), child: Text(rank, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWinner ? 14 : 10, color: isWinner ? Colors.white : Colors.black))),
            const SizedBox(height: 8),
            Text(data['name'] ?? '-', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.star, size: 12, color: Colors.orange), Text(" ${data['rating'] ?? 0}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))])
        ]),
      ),
    );
  }
}

class _RestoListCard extends StatelessWidget {
  final DocumentSnapshot doc; // GANTI DATA JADI DOC

  const _RestoListCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    var data = doc.data() as Map<String, dynamic>;
    var id = doc.id; // AMBIL ID

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPlacePage(placeData: data, placeId: id))), // KIRIM ID
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.black12, width: 1)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(18), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RichText(text: TextSpan(children: [TextSpan(text: data['price'] ?? '-', style: const TextStyle(color: JokkaColors.primary, fontWeight: FontWeight.bold, fontSize: 11)), TextSpan(text: " • ${data['location'] ?? '-'}", style: const TextStyle(color: Colors.black87, fontSize: 11))])),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.star, size: 14, color: Colors.orange), const SizedBox(width: 4), Text("${data['rating'] ?? 0.0}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
            ])),
        ]),
      ),
    );
  }
}