import 'package:chat_app/auth/controller/auth_controller.dart';
import 'package:chat_app/auth/repository/auth_repo.dart';
import 'package:chat_app/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());
  final AuthRepo _authRepo = Get.put(AuthRepo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          _authRepo.signOutUser();
          Get.to(() => LoginScreen());
          _authController.clearState();
        }, child: Text("Logout"))
      ),
    );
  }
}
