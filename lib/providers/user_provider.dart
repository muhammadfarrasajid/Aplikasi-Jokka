import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _role = 'user';
  String _fullName = '';
  bool _isLoading = false;

  User? get user => _user;
  String get role => _role;
  String get fullName => _fullName;
  bool get isLoading => _isLoading;

  bool get isAdmin => _role == 'admin';

  // 1. Cek User Saat Aplikasi Dibuka
  Future<void> checkCurrentUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _fetchUserRole();
    } else {
      notifyListeners();
    }
  }

  // 2. Fungsi Login
  Future<String?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      _user = result.user;
      
      await _fetchUserRole(); 
      
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    }
  }

  // 3. Fungsi Register
  Future<String?> signUp(String email, String password, String fullName) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      _user = result.user;

      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).set({
          'uid': _user!.uid,
          'email': email,
          'fullName': fullName,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        _role = 'user';
        _fullName = fullName;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Helper: Ambil Data Role & Nama dari Firestore
  Future<void> _fetchUserRole() async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _role = data['role'] ?? 'user';
          _fullName = data['fullName'] ?? '';
        }
      } catch (e) {
        print("Gagal ambil data user: $e");
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  // 5. Reset Password
  Future<String?> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 6. Logout
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _role = 'user';
    _fullName = '';
    notifyListeners();
  }
}