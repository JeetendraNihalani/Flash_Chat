import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/otp_login.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Resuse_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool showSpiner = false;
  String email;
  String password;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              ReuseButton(
                label: 'login',
                onPress: () async {
                  setState(() {
                    showSpiner = true;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    showSpiner = false;
                  } catch (e) {
                    print(e);
                  }
                },
                ButtonColor: Colors.lightBlueAccent,
              ),
              ReuseButton(
                label: 'Not Yet Register!!',
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                ButtonColor: Colors.red,
              ),
              // ReuseButton(
              //   label: 'Login By Google',
              //   onPress: () async {
              //     setState(() {
              //       isLoading = true;
              //     });
              //     FirebaseService service = new FirebaseService();
              //     try {
              //       await service.signInwithGoogle();
              //       Navigator.pushNamedAndRemoveUntil(
              //           context, ChatScreen.id, (route) => false);
              //     } catch (e) {
              //       if (e is FirebaseAuthException) {
              //         showMessage(e.message);
              //       }
              //     }
              //     setState(() {
              //       isLoading = false;
              //     });
              //   },
              //   ButtonColor: Colors.red,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<String> signInwithGoogle() async {
  //   try {
  //     final GoogleSignInAccount googleSignInAccount =
  //         await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //     throw e;
  //   }
  // }
  //
  // Future<void> signOutFromGoogle() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  // }
  //
  // void showMessage(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Error"),
  //           content: Text(message),
  //           actions: [
  //             TextButton(
  //               child: Text("Ok"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }
}
