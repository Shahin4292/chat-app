import 'package:chat_app/auth/controller/auth_controller.dart';
import 'package:chat_app/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController _authController = Get.put(AuthController());
  TextEditingController otpController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              "OTP Verification",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Enter the OTP sent to your phone number",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]
              ),
            )),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: otpController,
                maxLines: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),

              ),
            ),

            _authController.phoneAuthState.value.isLoading ? CircularProgressIndicator() :
            CustomButton(
              text: 'Verify OTP',
              onTap: () {
                _authController.verifyOtp(otp: otpController.text.trim(), context: context);
              },
            )
          ],
        ),
      ),
    );
  }
}
