import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/utils/Services/google_login.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';
import 'package:national_lawyer_assistant/Screens/splashScreen/ui/splash_screen.dart';
import 'package:national_lawyer_assistant/home.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';

import '../../Login/ui/login.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VeryEmailPageState();
}

class _VeryEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  String elevatedButtonText = "Send Verification Email";

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        showSnackBar(
          context,
          "No Internet Connection",
        );
      } else {
        showSnackBar(context, e.code.toString());
      }
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      await addUserToFirestore(); // Add user to Firestore after verification
    }
  }

  Future<void> addUserToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await AuthServices().addUserToFirestore(
        sign_in_method: FirebaseServices().getSignInMethod(user),
        uid: user.uid,
        email: user.email!,
        name: user.displayName ?? 'User',
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      showSnackBar(context, "Verification Email Sent. Check your Emails.");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Colors.black;
    final Color surface = Colors.white;

    return isEmailVerified
        ? HomeScreen()
        : Scaffold(
            backgroundColor: surface,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset(
                          'assets/images/otpimage.jpg', // Replace with your image asset
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Verify Email Address",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Roboto',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "An Email Has been sent to",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 111, 155, 191),
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          elevatedButtonText = "Resend Email";
                          sendVerificationEmail();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mail_lock_outlined),
                            SizedBox(width: 20),
                            Text(
                              elevatedButtonText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () async {
                          await AuthServices().logOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(width: 20),
                            Text(
                              "Go Back",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
