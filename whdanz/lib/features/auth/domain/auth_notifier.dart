import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_service.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseService _firebaseService;

  AuthNotifier(this._firebaseService) : super(const AuthState()) {
    _init();
  }

  void _init() {
    _firebaseService.authStateChanges.listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _firebaseService.signInWithEmailAndPassword(email, password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _firebaseService.createUserWithEmailAndPassword(email, password);
      if (user != null) {
        await _firebaseService.updateProfile(displayName: displayName);
        await _createUserDocument(user.uid, email, displayName);
      }
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<void> _createUserDocument(String uid, String email, String displayName) async {
    await _firebaseService.firestore.collection('users').doc(uid).set({
      'id': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': null,
      'bio': '',
      'followersCount': 0,
      'followingCount': 0,
      'postsCount': 0,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    state = const AuthState();
  }
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return AuthNotifier(firebaseService);
});
