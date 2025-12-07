import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/jokka_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<JokkaPlace>> getPlaces() {
    return _db.collection('places').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JokkaPlace.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<JokkaPlace>> getPlacesByCategory(String category) {
    return _db
        .collection('places')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => JokkaPlace.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<JokkaPlace>> getTopWisata() {
    return _db
        .collection('places')
        .where('category', isEqualTo: 'Wisata')
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
    return snapshot.docs.map((doc) => JokkaPlace.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<JokkaEvent>> getEvents() {
    return _db.collection('events').orderBy('start_date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JokkaEvent.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addPlace(JokkaPlace place) {
    return _db.collection('places').add(place.toJson());
  }

  Future<void> addEvent(JokkaEvent event) {
    return _db.collection('events').add({
      'name': event.name,
      'organizer': event.organizer,
      'description': event.description,
      'start_date': Timestamp.fromDate(event.startDate),
      'end_date': Timestamp.fromDate(event.endDate),
      'location': event.location,
      'ticket_price': event.ticketPrice,
      'image_url': event.imageUrl,
    });
  }

  Future<void> createUserProfile(JokkaUser user) {
    return _db.collection('users').doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'role': user.role,
    });
  }
}