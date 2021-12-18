import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'chat_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/Resuse_button.dart';

String mobileNumber;
String otp;

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String userEmail = "";

  TextEditingController phoneController =
      TextEditingController(text: "+917048619633");
  TextEditingController otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    controller.forward();
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: Image.asset(
                  'images/logo.png',
                  width: 110.0,
                  height: 125.0,
                )),
                Text(
                  'Flash',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  'chat',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 35.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),

          //designed and developed by team FLASH
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text('Designed & developed by Team   F L A S H .⚡',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Quicksand',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 70.0),
                Container(
                    child: Center(
                        child: Text(
                  'Enter with mobile number : ',
                  style: TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w100),
                ))),

                //Sizedbox is used for give spacing between the objects
                SizedBox(
                  height: 10.0,
                ),

                //Enter mobile number field.
                Container(
                    height: 50.0,
                    width: 250.0,
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.amber,
                        cursorWidth: 3.0,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.black.withAlpha(60),
                                fontFamily: 'Comfortaa'),
                            hintText: 'Enter mobile number.',
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                borderSide: BorderSide(
                                    color: Colors.amberAccent.shade700,
                                    width: 2.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2.0))),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          phoneController.text = "+91";
                          //Do something with the user input.
                          phoneController.text += value;
                          print(phoneController.text);
                        },
                      ),
                    )),

                //Enter otp field with Send otp button into the field.
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    height: 48.0,
                    width: 250.0,
                    child: Center(
                      child: Visibility(
                        child: TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.amber,
                          cursorWidth: 3.0,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black.withAlpha(60),
                                  fontFamily: 'Comfortaa'),
                              hintText: 'Enter OTP.',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    loginWithPhone();
                                  },
                                  icon: Icon(Icons.app_settings_alt),
                                  color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                  borderSide: BorderSide(
                                      color: Colors.amberAccent.shade700,
                                      width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0))),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            //Do something with the user input.
                            otp = value;
                          },
                        ),
                      ),
                    )),

                //Gradient Login Button
                SizedBox(height: 20.0),
                FlatButton(
                  onPressed: () {
                    verifyOTP();
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.blue])),
                    child: Center(
                      child: Text(
                        'Login',
                        style: (TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Comfortaa')),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 60.0),

                // A container with the text and some rounded buttons.
                Container(
                  child: Text(
                    'You can also Register / Login with : ',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 75.0),
                    IconButton(
                      onPressed: () async {
                        await signInWithGoogle();
                        setState(() {
                          if (userEmail != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        });
                      },
                      icon: Image.asset('images/g.png'),
                      iconSize: 50,
                    ),
                    SizedBox(width: 20.0),
                    IconButton(
                      onPressed: () {
                        setState(() async {
                          await signInWithFacebook();
                        });
                      },
                      icon: Image.asset('images/ff.png'),
                      iconSize: 60,
                    ),
                    SizedBox(width: 20.0),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      icon: Image.asset('images/m.png'),
                      iconSize: 50,
                    ),
                  ],
                )
              ],
            ),
            height: 600.0,

            //white box with rounded corner from topLeft and topRight
            //which you can say the body of the Screen.
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade900,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 15.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
          ),
        ],
      ),
    );
  }

  //Sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    userEmail = googleUser.email;
    print(userEmail);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign in with facebook
  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance
  //       .login(permissions: ['email', 'public_profile', 'user_birthday']);
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken.token);
  //
  //   final userData = await FacebookAuth.instance.getUserData();
  //
  //   userEmail = userData['email'];
  //   print("This is email of facebook user : " + userEmail);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  //login with mobile number
  void loginWithPhone() async {
    _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) {
          print("OTP Sent successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int resendToken) {
        print("Code sent");
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await _auth.signInWithCredential(credential).then((value) {
      print("You are logged in successfully");
      Navigator.pushNamed(context, ChatScreen.id);

      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}

class Resource {
  final Status status;
  Resource({this.status});
}

enum Status { Success, Error, Cancelled }
