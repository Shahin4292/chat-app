import 'package:chat_app/auth/controller/auth_controller.dart';
import 'package:chat_app/auth/repository/auth_repo.dart';
import 'package:chat_app/auth/screens/phone_auth_screen.dart';
import 'package:chat_app/base/custom_button.dart';
import 'package:chat_app/home/screens/home_screen.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());
  final AuthRepo _authRepo = Get.put(AuthRepo());

  void login() async {
    _authController.setLoading(true);
    final response  = await _authRepo.loginUser(
      email: _authController.state.value.email,
      password: _authController.state.value.password,
    );
    _authController.setLoading(false);
    if(response  == 'Login successful'){
      Get.to(() => HomeScreen());
      Get.snackbar('Success', response , backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', response , backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
            child: Obx(() => Column(
              children: [

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
                    errorText: _authController.state.value.emailError,
                  ),
                ),

                SizedBox(height: height * 0.02),

                TextField(
                  obscureText: _authController.state.value.isPasswordVisible,
                  autocorrect: false,
                  onChanged: (value) => _authController.updatePassword(value),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      errorText: _authController.state.value.passwordError,
                      suffixIcon: IconButton(onPressed: () => _authController.togglePasswordVisibility(), icon: Icon(_authController.state.value.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined))
                  ),
                ),

                SizedBox(height: height * 0.05),

                _authController.state.value.isLoading ? Center(child: CircularProgressIndicator()) :

                CustomButton(
                  text: 'Login',
                  onTap: _authController.state.value.isFormValid ? login : null,
                ),

                SizedBox(height: height * 0.02),

                CustomButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context){
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: PhoneAuthScreen(),
                          ),
                        );
                      }
                    );

                  },
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.phone, color: Colors.white,),
                      SizedBox(width: 10),
                      Text('Login with Phone', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(child: Container(
                      height: 1,
                      color: AppColor.primaryColor,
                    )),

                    Text(' Or '),

                    Expanded(child: Container(
                      height: 1,
                      color: AppColor.primaryColor,
                    )),

                    SizedBox(height: height * 0.02),

                  ],
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
            ),)
          ),
        ],
      ),
    );
  }
}
