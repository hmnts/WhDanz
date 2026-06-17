import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whdanz/core/services/api_service.dart';
import 'package:whdanz/core/services/firebase_service.dart';
import 'package:whdanz/features/auth/domain/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final FirebaseService _firebaseService;
  Future<void>? _initFuture;
  bool _isListeningToFirebase = false;

  AuthNotifier(this._apiService, this._firebaseService) : super(const AuthState()) {
    initializeAuth();
  }

  Future<void> _init() async {
    await _apiService.init();
    if (_apiService.token != null) {
      await _verifyToken();
    } else {
      _initFirebaseListener();
    }
  }

  Future<void> initializeAuth() async {
    _initFuture ??= _init();
    await _initFuture;
  }

  void _initFirebaseListener() {
    if (_isListeningToFirebase) {
      return;
    }

    _isListeningToFirebase = true;
    try {
      _firebaseService.authStateChanges.listen((firebaseUser) {
        if (firebaseUser != null) {
          _loadUserProfile(firebaseUser.uid);
        } else {
          state = const AuthState();
        }
      });
    } catch (error) {
      _isListeningToFirebase = false;
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  Future<void> _verifyToken() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _apiService.verifyToken();
      if (response['success'] == true) {
        final userData = response['user'];
        final profile = response['profile'];
        
        final user = UserModel(
          id: userData['uid'],
          email: userData['email'],
          displayName: userData['displayName'] ?? '',
          photoURL: userData['photoURL'],
          bio: profile?['bio'] ?? '',
          followersCount: profile?['followersCount'] ?? 0,
          followingCount: profile?['followingCount'] ?? 0,
          postsCount: profile?['postsCount'] ?? 0,
          createdAt: profile?['createdAt'] != null 
            ? DateTime.parse(profile['createdAt']) 
            : DateTime.now(),
          updatedAt: profile?['updatedAt'] != null 
            ? DateTime.parse(profile['updatedAt']) 
            : DateTime.now(),
        );
        
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
      _initFirebaseListener();
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final response = await _apiService.getUser(uid);
      if (response['success'] == true) {
        final profile = response['user'];
        final user = UserModel.fromJson(profile);
        state = state.copyWith(user: user, isAuthenticated: true);
      }
    } catch (e) {
      // Silently fail, user data will be minimal
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.login(email: email, password: password);
      
      if (response['success'] == true) {
        final userData = response['user'];
        
        final user = UserModel(
          id: userData['uid'],
          email: userData['email'],
          displayName: userData['displayName'] ?? '',
          photoURL: userData['photoURL'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        
        await _loadUserProfile(user.id);
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error de conexión');
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      
      if (response['success'] == true) {
        final userData = response['user'];
        
        final user = UserModel(
          id: userData['uid'],
          email: userData['email'],
          displayName: userData['displayName'] ?? displayName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error de conexión');
      return false;
    }
  }

  Future<void> signOut() async {
    await _apiService.logout();
    try {
      await _firebaseService.signOut();
    } catch (error) {
      // Firebase may be unavailable in local API-only runs.
    }
    state = const AuthState();
  }

  Future<bool> updateProfile({String? displayName, String? bio, String? photoURL}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.updateProfile(
        displayName: displayName,
        bio: bio,
        photoURL: photoURL,
      );
      
      if (response['success'] == true) {
        final profile = response['profile'];
        final updatedUser = state.user?.copyWith(
          displayName: profile['displayName'] ?? state.user?.displayName,
          bio: profile['bio'] ?? state.user?.bio,
          photoURL: profile['photoURL'] ?? state.user?.photoURL,
          updatedAt: DateTime.now(),
        );
        
        state = state.copyWith(user: updatedUser, isLoading: false);
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error al actualizar');
      return false;
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final firebaseService = ref.watch(firebaseServiceProvider);
  return AuthNotifier(apiService, firebaseService);
});
