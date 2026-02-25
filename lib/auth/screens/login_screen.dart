import 'package:chat_app/base/custom_button.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      body: Column(
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
            child: Column(
              children: [

                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),

                SizedBox(height: height * 0.02),

                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.password_outlined),
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),

                SizedBox(height: height * 0.05),

                CustomButton(
                  text: 'Login',
                  onTap: () {
                    // Handle login logic here
                  },
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: Text('Sign Up', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                    Text('Don\'t have an account? '),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
