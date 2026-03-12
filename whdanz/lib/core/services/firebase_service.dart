import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  
  FirebaseService._();
  
  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }
  
  User? get currentUser => auth.currentUser;
  
  Stream<User?> get authStateChanges => auth.authStateChanges();
  
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }
  
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }
  
  Future<void> signOut() async {
    await auth.signOut();
  }
  
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    await currentUser?.updateDisplayName(displayName);
    if (photoURL != null) {
      await currentUser?.updatePhotoURL(photoURL);
    }
  }
}
