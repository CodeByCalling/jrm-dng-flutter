import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign In (Strict)
  Future<void> signIn(String email, String password) async {
    try {
      print("🔥 AUTH SERVICE: Attempting Real Login for $email");
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("✅ AUTH SERVICE: Success!");
    } on FirebaseAuthException catch (e) {
      print("❌ AUTH SERVICE ERROR: ${e.code}");
      throw e.message ?? 'Login failed';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
