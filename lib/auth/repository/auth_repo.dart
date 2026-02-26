import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up user with name, email and password
  Future<String> signUpUser({
  required String name,
  required String email,
  required String password}) async {
    try{
      if(name.isEmpty || email.isEmpty || password.isEmpty){
        return 'Please fill in all fields';
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "uid": userCredential.user!.uid,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
      return 'Sign up successful';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return 'An error occurred';
    }
  }


  // login user with email and password
  Future<String> loginUser({
    required String email,
    required String password}) async {
    try{
      if(email.isEmpty || password.isEmpty){
        return 'Please fill in all fields';
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Login successful';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return 'An error occurred';
    }
  }

  // Logout user
  Future<void> signOutUser() async {
    await _auth.signOut();
}
}
