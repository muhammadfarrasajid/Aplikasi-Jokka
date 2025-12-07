import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  void checkCurrentUser() {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      _user = result.user;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      _user = result.user;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}