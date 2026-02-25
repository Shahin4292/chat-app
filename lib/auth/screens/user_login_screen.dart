import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/image_path.dart';
import 'package:flutter/material.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

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

        ],
      ),
    );
  }
}
