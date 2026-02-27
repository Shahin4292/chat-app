import 'package:chat_app/auth/controller/auth_controller.dart';
import 'package:chat_app/base/custom_button.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final AuthController _authController = Get.put(AuthController());
  TextEditingController phoneController = TextEditingController();
  String countryCode = '+880';

  @override
  void dispose() {
      phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [

           SizedBox(height: Dimensions.height * 0.02),
           const Text("Phone Authentication", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: Dimensions.height * 0.02),

            IntlPhoneField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              initialCountryCode: 'BD',
              onCountryChanged: (country) {
                countryCode = '+${country.dialCode}';
              },
              // onChanged: (phone) {
              //   print(phone.completeNumber);
              // },
            ),

            SizedBox(height: Dimensions.height * 0.02),

            _authController.phoneAuthState.value.isLoading ? CircularProgressIndicator() :

            CustomButton(
              text: 'Send OTP',
              onTap: () {
                final phoneNumber = '$countryCode${phoneController.text.trim()}';
                _authController.sendVerificationCode(phoneNumber: phoneNumber, context: context);
              },)

          ],
        ),
        Positioned(
          top: -15,
          right: -15,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          )
        )
      ],
    );
  }
}
