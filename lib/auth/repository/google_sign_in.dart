import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Sign in and store user data in Firestore
  Future<User?> signInWithGoogle({required String webClientId}) async {
    try {
      await _googleSignIn.initialize(clientId: webClientId);
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) return null;

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Store user info in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSignIn': DateTime.now(),
        }, SetOptions(merge: true)); // merge true to update existing data
      }

      return user;
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}