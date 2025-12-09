import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_theme.dart';

class DetailPlacePage extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const DetailPlacePage({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final double lat = (placeData['latitude'] ?? 0.0).toDouble();
    final double long = (placeData['longitude'] ?? 0.0).toDouble();
    final bool hasLocation = lat != 0.0 && long != 0.0;

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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                placeData['imageUrl'] ?? 'https://picsum.photos/500',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[300]),
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
                            placeData['name'] ?? 'Tanpa Nama',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                (placeData['rating'] ?? 0.0).toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: JokkaColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            placeData['location'] ?? 'Alamat tidak tersedia',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          placeData['price'] ?? 'Gratis',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Deskripsi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      placeData['description'] ?? '-',
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Lokasi Peta",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: hasLocation
                            ? FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(lat, long),
                                  initialZoom: 15.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(lat, long),
                                        width: 80,
                                        height: 80,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.map_outlined,
                                        size: 50, color: Colors.grey),
                                    SizedBox(height: 10),
                                    Text("Koordinat tidak valid"),
                                  ],
                                ),
                              ),
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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Nanti bisa tambah fitur 'Buka di Google Maps'
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: JokkaColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text(
            "Lihat Rute",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}