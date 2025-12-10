import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jrm_dng_flutter/features/auth/services/auth_service.dart';

// AUTH STATE MODEL
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isOfficialMember;
  final User? user;
  final bool? profileFound;
  final String? membershipStatus;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isOfficialMember = false,
    this.user,
    this.profileFound,
    this.membershipStatus,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isOfficialMember,
    User? user,
    bool? profileFound,
    String? membershipStatus,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isOfficialMember: isOfficialMember ?? this.isOfficialMember,
      user: user ?? this.user,
      profileFound: profileFound ?? this.profileFound,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      error: error ?? this.error,
    );
  }
}

// AUTH NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) async {
      if (!mounted) return;

      if (user == null) {
        state = const AuthState(isLoading: false, isAuthenticated: false);
      } else {
        // CRITICAL: Set loading while we fetch attributes to prevent Router race conditions
        state = state.copyWith(isLoading: true);
        await _fetchUserAttributes(user);
      }
    });
  }

  Future<void> _fetchUserAttributes(User user) async {
    // Debug prints
    print('Fetching Profile for UID: ${user.uid}');
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      print('Document Found: ${doc.exists}');
      print('Raw Data: ${doc.data()}');
      bool isMember = false;
      String? membershipStatus;
      bool profileFound = false;

      if (doc.exists) {
        profileFound = true;
        final data = doc.data();
        if (data != null && data.containsKey('isOfficialMember')) {
          isMember = data['isOfficialMember'] == true;
        }
        if (data != null && data.containsKey('membershipStatus')) {
          membershipStatus = data['membershipStatus']?.toString();
        }
      }

      if (mounted) {
        state = AuthState(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          isOfficialMember: isMember,
          profileFound: profileFound,
          membershipStatus: membershipStatus,
        );
      }
    } catch (e) {
      if (mounted) {
        // Fallback to authenticated but not verified if firestore fails
        state = AuthState(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          isOfficialMember: false,
          profileFound: false,
          membershipStatus: null,
          error: "Firestore Sync Failed: $e",
        );
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signIn(email, password);
      // Listener will handle state update
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
      rethrow; // Propagate to UI
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Listener will handle state update
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}

// PROVIDER DEFINITION
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
