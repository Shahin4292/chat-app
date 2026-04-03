import 'dart:async';
import 'dart:io';

import 'package:chat_app/profile/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> state = ProfileModel(isLoading: true).obs;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthChanges();
    loadUserData(); // VERY IMPORTANT
  }

  void _listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        if (state.value.userId != user.uid) {
          loadUserData();
        } else {
          state.value = state.value.copyWith(isLoading: false);
        }
      }
    });
  }

  Future<void> loadUserData([User? user]) async {
    final currentUser = user ?? FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      state.value = state.value.copyWith(isLoading: false);
      return;
    }

    state.value = state.value.copyWith(isLoading: true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        state.value = state.value.copyWith(
          userId: currentUser.uid,
          name: data['name'] ?? 'No Name',
          email: data['email'],
          photoUrl: data['photoURL'],
          // ✅ FIXED
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
          // ✅ FIXED
          isLoading: false,
        );
      } else {
        state.value = state.value.copyWith(
          userId: currentUser.uid,
          isLoading: false,
        );
      }
    } catch (e) {
      state.value = state.value.copyWith(
        userId: currentUser.uid,
        isLoading: false,
      );

      Get.snackbar('Error', 'Failed to load user data: $e');
    }
  }

  // Future<void> loadUserData([User? user]) async {
  //   final currentUser = user ?? FirebaseAuth.instance.currentUser;
  //   // final user = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     state.value = state.value.copyWith(isLoading: false);
  //     return;
  //   }
  //   state.value = state.value.copyWith(isLoading: true);
  //   try{
  //     final doc = await FirebaseAuth.instance.collection('users').doc(currentUser.uid).get();
  //     if(doc.exists) {
  //       state = state.value.copyWith(
  //         userId: currentUser.uid,
  //         name: doc['name'] ?? 'No Name',
  //         email: doc['email'],
  //         photoUrl: doc['photoUrl'],
  //         createdAt: (doc['createdAt'] as Timestamp?)?.toDate(),
  //         isLoading: false,
  //       ).obs;
  //     }else{
  //       state = state.value.copyWith(
  //         userId: currentUser.uid,
  //         isLoading: false,
  //       ).obs;
  //     }
  //   }catch(e){
  //     state.value = state.value.copyWith(
  //       userId: currentUser.uid,
  //       isLoading: false,
  //     );
  //     Get.snackbar('Error', 'Failed to load user data: $e');
  //   }
  // }

  void refreshProfile() {
    loadUserData();
  }

  Future<bool> updateProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return false;

    state.value = state.value.copyWith(isUpLoading: true);

    File file = File(pickedFile.path);

    try {
      // ✅ Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child("${user.uid}.jpg");

      await storageRef.putFile(file);

      // ✅ Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // ✅ Save URL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'photoUrl': downloadUrl},
      );

      // ✅ Update local state
      state.value = state.value.copyWith(
        photoUrl: downloadUrl,
        isUpLoading: false,
      );

      return true;
    } catch (e) {
      state.value = state.value.copyWith(isUpLoading: false);
      Get.snackbar('Error', 'Failed to update profile picture: $e');
      return false;
    }
  }
}
