import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  User? user;
  bool isLoading = true;

  AuthProvider() {
    try {
      _service.authStateChanges().listen((u) {
        user = u;
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      // If Firebase isn't available (for example in tests), avoid throwing.
      user = null;
      isLoading = false;
      notifyListeners();
    }
  }

  bool get isSignedIn => user != null;

  Future<String?> signIn(String email, String password) async {
    try {
      await _service.signIn(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _service.signUp(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
  }
}
