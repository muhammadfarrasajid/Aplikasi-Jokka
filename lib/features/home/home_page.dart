import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/user_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/notification_service.dart';
import '../../screen/kuliner/kuliner_screen.dart';
import '../../screen/wisata/top_wisata_page.dart';
import '../../screen/detail/detail_place_page.dart';
import '../../screen/event/event_page.dart';
import '../../core/widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Semua';

  final List<Map<String, String>> floatingMenus = [
    {'icon': 'top', 'label': 'Top Wisata'},
    {'icon': 'event', 'label': 'Event'},
    {'icon': 'kuliner', 'label': 'Kuliner'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermissionOnce();
    });
  }

  Future<void> _requestNotificationPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyRequested = prefs.getBool('notifications_permission_requested') ?? false;
    if (alreadyRequested) return;

    await prefs.setBool('notifications_permission_requested', true);
    await NotificationService().requestPermission();
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    CollectionReference places = FirebaseFirestore.instance.collection('places');

    if (_selectedCategory == 'Semua') {
      return places.orderBy('createdAt', descending: true).limit(5).snapshots();
    } else {
      return places
          .where('category', isEqualTo: _selectedCategory.toLowerCase())
          .limit(5)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_jokka_header.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                "JOKKA",
                style: TextStyle(color: JokkaColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 32),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pilihan Jokka Terbaru", style: headingStyle),
                  const SizedBox(height: 10),
                  
                  SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip("Semua"),
                        _buildChip("Wisata"),
                        _buildChip("Event"), 
                        _buildChip("Kuliner"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  StreamBuilder<QuerySnapshot>(
                    stream: _getFilteredStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          height: 100,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[200]!)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                "Belum ada data ${_selectedCategory.toLowerCase()}.",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var doc = docs[index];
                          var data = doc.data() as Map<String, dynamic>;
                          var id = doc.id;
                          return _buildRealVerticalCard(data, id);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: const Text("Destinasi Wisata", style: headingStyle)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'wisata').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Container(alignment: Alignment.center, margin: const EdgeInsets.only(left: 20), child: const Text("Belum ada data wisata", style: TextStyle(color: Colors.grey)));
                  final docs = snapshot.data!.docs;
                  return ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 20), itemCount: docs.length, itemBuilder: (context, index) {
                    var doc = docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                    var id = doc.id;
                    return _buildRealHorizontalCard(data, id);
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: const Text("Event Pilihan", style: headingStyle)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'event').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Container(alignment: Alignment.center, margin: const EdgeInsets.only(left: 20), child: const Text("Belum ada data event", style: TextStyle(color: Colors.grey)));
                  final docs = snapshot.data!.docs;
                  return ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 20), itemCount: docs.length, itemBuilder: (context, index) {
                    var doc = docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                    var id = doc.id;
                    return _buildRealHorizontalCard(data, id);
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: const Text("Kuliner Wajib Coba", style: headingStyle)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').where('category', isEqualTo: 'kuliner').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Container(alignment: Alignment.center, margin: const EdgeInsets.only(left: 20), child: const Text("Belum ada data kuliner", style: TextStyle(color: Colors.grey)));
                  final docs = snapshot.data!.docs;
                  return ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 20), itemCount: docs.length, itemBuilder: (context, index) {
                    var doc = docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                    var id = doc.id;
                    return _buildRealHorizontalCard(data, id);
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final userProvider = Provider.of<UserProvider>(context);
    String displayName = "Jokka";
    if (userProvider.fullName.isNotEmpty) {
      List<String> words = userProvider.fullName.split(' ');
      displayName = words.length >= 2 ? "${words[0]} ${words[1]}" : words[0];
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back_image.png'), 
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
            )
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent]
            )
          )
        ),
        Positioned(
          top: 150,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.0)
                ],
                stops: const [0.0, 0.4, 1.0],
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Halo, $displayName", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              const Text("Mau kemana hari ini?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70)),
          ]),
        ),
        Positioned(bottom: -50, left: 20, right: 20, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: floatingMenus.map((menu) {
              return GestureDetector(
                onTap: () {
                  if (menu['label'] == 'Kuliner') Navigator.push(context, MaterialPageRoute(builder: (context) => const KulinerScreen()));
                  else if (menu['label'] == 'Top Wisata') Navigator.push(context, MaterialPageRoute(builder: (context) => const TopWisataPage()));
                  else if (menu['label'] == 'Event') Navigator.push(context, MaterialPageRoute(builder: (context) => const EventPage()));
                  else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Menu ${menu['label']} segera hadir!")));
                },
                child: Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(menu['label'] == 'Top Wisata' ? Icons.landscape : menu['label'] == 'Event' ? Icons.event : Icons.restaurant, color: JokkaColors.primary, size: 32), const SizedBox(height: 10), Text(menu['label']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))])),
              );
            }).toList()))
      ],
    );
  }

  Widget _buildChip(String label) {
    bool isActive = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? JokkaColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w600
          )
        )
      ),
    );
  }

  Widget _buildRealVerticalCard(Map<String, dynamic> data, String id) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPlacePage(placeData: data, placeId: id))),
      child: Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)), child: Row(children: [Container(width: 80, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/200'), fit: BoxFit.cover))), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text(data['description'] ?? 'Tidak ada deskripsi', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12)), const SizedBox(height: 5), Row(children: [const Icon(Icons.star, color: Colors.orange, size: 14), Text(" ${data['rating'] ?? 0.0}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))])]))])));
  }

  Widget _buildRealHorizontalCard(Map<String, dynamic> data, String id) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPlacePage(placeData: data, placeId: id))),
      child: Container(width: 160, margin: const EdgeInsets.only(right: 15, bottom: 5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), image: DecorationImage(image: NetworkImage(data['imageUrl'] ?? 'https://picsum.photos/201'), fit: BoxFit.cover)))), Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 2), Text(data['location'] ?? 'Lokasi tidak ada', style: TextStyle(color: Colors.grey[500], fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)]))])));
  }
}