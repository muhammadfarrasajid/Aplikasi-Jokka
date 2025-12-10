import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = _dummyEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Event Jokka',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final e = events[index];
          return _EventCard(event: e);
        },
      ),
    );
  }
}

class _Event {
  final String title;
  final String date;
  final String location;
  final String imageUrl;

  const _Event({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
  });
}

/// SEMENTARA pakai dummy dulu biar tampilan jadi.
/// Nanti kalau mau, baru diganti data dari Firestore.
const _dummyEvents = <_Event>[
  _Event(
    title: 'Festival Budaya Makassar',
    date: '12 Desember 2025',
    location: 'Lapangan Karebosi',
    imageUrl:
        'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg',
  ),
  _Event(
    title: 'Konser Musik Pantai Losari',
    date: '20 Desember 2025',
    location: 'Pantai Losari',
    imageUrl:
        'https://images.pexels.com/photos/1647161/pexels-photo-1647161.jpeg',
  ),
  _Event(
    title: 'Jelajah Kuliner Malam',
    date: '30 Desember 2025',
    location: 'Sentra Kuliner Makassar',
    imageUrl:
        'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg',
  ),
];

class _EventCard extends StatelessWidget {
  final _Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // gambar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(event.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          // teks
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
    );
  }
}
