import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Placeholder Auth Provider
final authProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Placeholder for user object
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    // Implement standard Firebase Sign In
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String mobile,
  }) async {
    // 1. Create User
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Write initial document
    if (cred.user != null) {
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'fullName': fullName,
        'mobile': mobile,
        'role': 'guest',
        'membershipStatus': 'pending_101',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Method to impersonate or "act as" for testing (optional, if requested later)
}
