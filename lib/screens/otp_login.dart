import 'package:flash_chat/Resuse_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

class OtpLogin extends StatefulWidget {
  static const String id = "otp_screen";

  @override
  _OtpLoginState createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  String mobileNumber;
  var OTP;
  var ResultOTP;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                mobileNumber = value;
                print(mobileNumber);
              },
              decoration:
                  kInputDecoration.copyWith(hintText: 'Enter Mobile Number'),
            ),
            ReuseButton(
              label: 'Send OTP',
              onPress: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+917048619633',
                  verificationCompleted:
                      (PhoneAuthCredential credential) async {},
                  verificationFailed: (FirebaseAuthException e) async {},
                  codeSent: (String verificationId, int resendToken) async {},
                  codeAutoRetrievalTimeout: (String verificationId) async {},
                );
                ConfirmationResult confirmationResult =
                    await _auth.signInWithPhoneNumber(mobileNumber);
                print('OTP : $confirmationResult');
              },
              ButtonColor: Colors.grey,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                OTP = value;
              },
              decoration: kInputDecoration.copyWith(hintText: 'Enter OTP'),
            ),
            ReuseButton(
              label: 'Login',
              onPress: () {
                if (ResultOTP == OTP) {
                  // Navigator.pushNamed(context, ChatScreen.id);
                }
              },
              ButtonColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
