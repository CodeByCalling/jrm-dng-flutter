import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthNotifier manages the authentication state using Firebase Auth.
/// It uses AsyncValue<User?> to represent loading, error, and data (User or null) states.
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.data(null)) {
    // Check initial user
    final currentUser = FirebaseAuth.instance.currentUser;
    state = AsyncValue.data(currentUser);

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    }, onError: (error, stack) {
      state = AsyncValue.error(error, stack);
    });
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // State updates automatically via the listener
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // State updates automatically via the listener
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // State updates automatically via the listener
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});
