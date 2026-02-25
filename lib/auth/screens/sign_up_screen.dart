import 'package:chat_app/auth/controller/auth_controller.dart';
import 'package:chat_app/auth/repository/auth_repo.dart';
import 'package:chat_app/base/custom_button.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.put(AuthController());
  final AuthRepo _authRepo = Get.put(AuthRepo());

  void signUp() async {
    _authController.setLoading(true);
    final request = await _authRepo.signUpUser(
      name: _authController.state.value.name,
      email: _authController.state.value.email,
      password: _authController.state.value.password,
    );
    _authController.setLoading(false);
    if(request == 'Sign up successful'){
      Get.to(() => LoginScreen());
      Get.snackbar('Success', request, backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', request, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              height: height * 0.3,
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColor.shadowColor,
                      blurRadius: 15,
                      spreadRadius: 20
                  ),
                ],
              ),
              child: Image.asset(ImagePath.sign, fit: BoxFit.cover),
            ),

            SizedBox(height: height * 0.05),

            Padding(
              padding: EdgeInsets.all(15),
              child: Obx(() => Column(
                children: [

                  TextField(
                    autocorrect: false,
                    onChanged: (value) => _authController.updateName(value),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        errorText: _authController.state.value.nameError
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  TextField(
                    autocorrect: false,
                    onChanged: (value) => _authController.updateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        errorText: _authController.state.value.emailError
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  TextField(
                    autocorrect: false,
                    onChanged: (value) => _authController.updatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined),
                        labelText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        errorText: _authController.state.value.passwordError
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  _authController.state.value.isLoading ? Center(child: CircularProgressIndicator()) :
                  CustomButton(
                    text: 'Sign Up',
                    onTap: _authController.state.value.isFormValid ? signUp : null,
                  ),

                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child: Text('Login', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                      Text('Already have an account? '),
                    ],
                  )
                ],
              ),)
            ),
          ],
        ),
      ),
    );
  }
}
