// import 'package:chat_app/auth/model/auth_form_state_model.dart';
// import 'package:get/get.dart';
//
// class AuthController extends GetxController{
//    AuthFormStateModel state = AuthFormStateModel();
//
//
//   void togglePasswordVisibility() {
//     state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
//   }
//
//   void updateName(String name) {
//     String? nameError;
//     if (name.isNotEmpty && name.length < 6) {
//       nameError = 'Provide your full name';
//     }
//     update();
//     state = state.copyWith(name: name, nameError: nameError);
//   }
//
//   void updateEmail(String email) {
//     String? emailError;
//     if (email.isNotEmpty && !GetUtils.isEmail(email)) {
//       emailError = 'Enter a valid email';
//     }
//     update();
//     state = state.copyWith(name: email, nameError: emailError);
//   }
//
//   void updatePassword(String password) {
//     String? passwordError;
//     if (password.isNotEmpty && password.length < 6) {
//       passwordError = 'Password must be at least 6 characters';
//     }
//     update();
//     state = state.copyWith(name: password, nameError: passwordError);
//   }
//
//   void setLoading(bool isLoading) {
//     state = state.copyWith(isLoading: isLoading);
//   }
// }

// ---------------------------
// auth_controller.dart
// ---------------------------
import 'package:chat_app/auth/model/auth_form_state_model.dart';
import 'package:chat_app/auth/model/phone_auth_model.dart';
import 'package:chat_app/auth/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/screens/home_screen.dart';

class AuthController extends GetxController {
  // Make state reactive
  Rx<AuthFormStateModel> state = AuthFormStateModel().obs;
  Rx<PhoneAuthModel> phoneAuthState = PhoneAuthModel().obs;

  void clearState() {
    state.value = state.value.copyWith(
      name: '',
      email: '',
      password: '',
      nameError: null,
      emailError: null,
      passwordError: null,
      isPasswordVisible: false,
      isLoading: false,
    );
  }

  Future<void> sendVerificationCode({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    if(phoneNumber.isEmpty || phoneNumber.length < 7) {
      phoneAuthState.value = phoneAuthState.value.copyWith(error: 'Please enter a valid phone number');
      return;
    }
    phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: true, error: null, phoneNumber: phoneNumber);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await FirebaseAuth.instance.signInWithCredential(credential);
              phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false);
              Get.snackbar('Success', 'Phone number verified successfully', backgroundColor: Colors.green, colorText: Colors.white);
              Get.to(() => HomeScreen());
            }catch (e) {
              phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: e.toString());
            }
          },
          verificationFailed: ( FirebaseAuthException error) {
            phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: error.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: null, verificationId: verificationId);
            Get.snackbar('Code Sent', 'Verification code sent to $phoneNumber', backgroundColor: Colors.green, colorText: Colors.white);
            Get.to(() => OtpScreen());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: 'Code auto retrieval timed out', verificationId: verificationId);
          }
      );
    }catch (e) {
      phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required BuildContext context,
  }) async {
    if(otp.isEmpty || otp.length < 6) {
      phoneAuthState.value = phoneAuthState.value.copyWith(error: 'Please enter a valid OTP');
      return;
    }
    phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: true, error: null);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: phoneAuthState.value.verificationId!,
          smsCode: otp
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false);
      Get.snackbar('Success', 'Phone number verified successfully', backgroundColor: Colors.green, colorText: Colors.white);
      Get.to(() => HomeScreen());
    }catch (e) {
      phoneAuthState.value = phoneAuthState.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateName(String name) {
    String? nameError;
    if (name.isNotEmpty && name.length < 6) {
      nameError = 'Provide your full name';
    }
    state.value = state.value.copyWith(name: name, nameError: nameError);
  }

  void updateEmail(String email) {
    String? emailError;
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      emailError = 'Enter a valid email';
    }
    state.value = state.value.copyWith(email: email, emailError: emailError);
  }

  void updatePassword(String password) {
    String? passwordError;
    if (password.isNotEmpty && password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }
    state.value =
        state.value.copyWith(password: password, passwordError: passwordError);
  }

  void togglePasswordVisibility() {
    state.value = state.value
        .copyWith(isPasswordVisible: !state.value.isPasswordVisible);
  }

  void setLoading(bool isLoading) {
    state.value = state.value.copyWith(isLoading: isLoading);
  }
}