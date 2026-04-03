import 'package:chat_app/profile/controller/profile_controller.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  String? lastUserId;

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    lastUserId = currentUser?.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _profileController.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // if(_profileController.state.value.isLoading) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(fontWeight: .w600)),
        actions: [
          IconButton(
            onPressed: () => _profileController.refresh(),
            tooltip: "Refresh Profile",
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
        body: Padding(padding: const EdgeInsets.all(16), child: Obx(() {
      final profile = _profileController.state.value;
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profile.photoUrl != null
                ? NetworkImage(profile.photoUrl!)
                : null,
            child: profile.photoUrl == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 16),
          Text(profile.name ?? 'No Name', style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(profile.email ?? 'No Email',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          if (profile.createdAt != null)
            Text('Joined on ${profile.createdAt!.toLocal().toString().split(
                ' ')[0]}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      );
    })
    ));
  }
}
