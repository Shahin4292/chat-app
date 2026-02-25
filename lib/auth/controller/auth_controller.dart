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
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Make state reactive
  Rx<AuthFormStateModel> state = AuthFormStateModel().obs;

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