import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../admin/edit_place_page.dart';

class DetailPlacePage extends StatefulWidget {
  final Map<String, dynamic> placeData;
  final String placeId;

  const DetailPlacePage({
    super.key, 
    required this.placeData,
    required this.placeId,
  });

  @override
  State<DetailPlacePage> createState() => _DetailPlacePageState();
}

class _DetailPlacePageState extends State<DetailPlacePage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final double lat = (widget.placeData['latitude'] ?? 0.0).toDouble();
    final double long = (widget.placeData['longitude'] ?? 0.0).toDouble();
    final bool hasLocation = lat != 0.0 && long != 0.0;
    final LatLng placeLocation = LatLng(lat, long);

    if (hasLocation) {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.placeData['name'] ?? 'place'),
          position: placeLocation,
          infoWindow: InfoWindow(title: widget.placeData['name']),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),

            actions: userProvider.isAdmin ? [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPlacePage(
                        placeId: widget.placeId,
                        currentData: widget.placeData,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                  child: const Icon(Icons.edit, color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () => _confirmDelete(context),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ] : null,

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.placeData['imageUrl'] ?? 'https://picsum.photos/500',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                transform: Matrix4.translationValues(0, -20, 0),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.placeData['name'] ?? 'Tanpa Nama',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text((widget.placeData['rating'] ?? 0.0).toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: JokkaColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.placeData['location'] ?? '-', style: TextStyle(color: Colors.grey[600]))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(widget.placeData['price'] ?? 'Gratis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      widget.placeData['description'] ?? '-',
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    const Text("Lokasi Peta (Google Maps)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[300]!)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: hasLocation
                            ? GoogleMap(
                                onMapCreated: (c) => mapController = c,
                                initialCameraPosition: CameraPosition(target: placeLocation, zoom: 15.0),
                                markers: _markers,
                              )
                            : const Center(child: Text("Koordinat tidak valid")),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: JokkaColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text("Lihat Rute", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Data?"),
        content: const Text("Data yang dihapus tidak bisa dikembalikan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              await FirebaseFirestore.instance.collection('places').doc(widget.placeId).delete();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
                Navigator.pop(context);
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}