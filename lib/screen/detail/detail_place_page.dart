import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_theme.dart';

class DetailPlacePage extends StatefulWidget {
  final Map<String, dynamic> placeData;

  const DetailPlacePage({super.key, required this.placeData});

  @override
  State<DetailPlacePage> createState() => _DetailPlacePageState();
}

class _DetailPlacePageState extends State<DetailPlacePage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final double lat = (widget.placeData['latitude'] ?? 0.0).toDouble();
    final double long = (widget.placeData['longitude'] ?? 0.0).toDouble();
    final bool hasLocation = lat != 0.0 && long != 0.0;
    
    final LatLng placeLocation = LatLng(lat, long);

    if (hasLocation) {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.placeData['name'] ?? 'place'),
          position: placeLocation,
          infoWindow: InfoWindow(
            title: widget.placeData['name'],
            snippet: widget.placeData['location'],
          ),
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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.placeData['imageUrl'] ?? 'https://picsum.photos/500',
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
                            widget.placeData['name'] ?? 'Tanpa Nama',
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
                                (widget.placeData['rating'] ?? 0.0).toString(),
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
                            widget.placeData['location'] ?? 'Alamat tidak tersedia',
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
                          widget.placeData['price'] ?? 'Gratis',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Deskripsi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.placeData['description'] ?? '-',
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Lokasi Peta (Google Maps)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            ? GoogleMap(
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },
                                initialCameraPosition: CameraPosition(
                                  target: placeLocation,
                                  zoom: 15.0,
                                ),
                                markers: _markers,
                                mapType: MapType.normal,
                                zoomControlsEnabled: true,
                                myLocationButtonEnabled: false,
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
    );
  }
}