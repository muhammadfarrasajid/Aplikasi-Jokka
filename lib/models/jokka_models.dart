import 'package:cloud_firestore/cloud_firestore.dart';

class JokkaPlace {
  final String id;
  final String name;
  final String category;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double rating;
  final List<String> facilities;

  JokkaPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.rating,
    required this.facilities,
  });

  factory JokkaPlace.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JokkaPlace(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'wisata',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      facilities: List<String>.from(data['facilities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'rating': rating,
      'facilities': facilities,
    };
  }
}

class JokkaEvent {
  final String id;
  final String name;
  final String organizer;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final double ticketPrice;
  final String imageUrl;

  JokkaEvent({
    required this.id,
    required this.name,
    required this.organizer,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.ticketPrice,
    required this.imageUrl,
  });

  factory JokkaEvent.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JokkaEvent(
      id: doc.id,
      name: data['name'] ?? '',
      organizer: data['organizer'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['start_date'] as Timestamp).toDate(),
      endDate: (data['end_date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      ticketPrice: (data['ticket_price'] ?? 0).toDouble(),
      imageUrl: data['image_url'] ?? '',
    );
  }
}

class JokkaUser {
  final String id;
  final String name;
  final String email;
  final String role;

  JokkaUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory JokkaUser.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JokkaUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
    );
  }
}