import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/google_login.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/verify_email.dart';
import 'package:national_lawyer_assistant/Login/Phone%20authentication/phone_authentication.dart';
import 'package:national_lawyer_assistant/Login/Screens/sign_up.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';
import 'package:national_lawyer_assistant/Login/Widget/button.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/Login/Widget/text_field.dart';
import 'package:national_lawyer_assistant/Login/forgot_password/forgot_password.dart';
import 'package:national_lawyer_assistant/splash.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logInUser() async {
    String res = await AuthServices().logIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "Login Successfull") {
      setState(() {
        isLoading = true;
      });
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
        );
      } else {
        showSnackBar(context, "Please verify your email");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(),
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void googleLogInUser() async {
    String res = await FirebaseServices().signInWithGoogle();

    if (res == "Login Successfull") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color secondary = Theme.of(context).colorScheme.secondary;
    final Color surface = Theme.of(context).colorScheme.surface;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
        ? "assets/images/Logo_dark.png"
        : "assets/images/Logo_bright.png";
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: height / 3,
                    child: Image.asset(logoAsset),
                  ),
                ),
                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter your password",
                  icon: Icons.lock,
                  isPass: true,
                ),
                ForgotPassword(),
                AppButton(onTab: logInUser, text: "Log in"),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      Expanded(child: Container(height: 1, color: secondary)),
                      Text(
                        " OR CONTINUE WITH ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: secondary)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: height / 9,
                      height: height / 9.5,
                      child: InkWell(
                        onTap: () {
                          googleLogInUser();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/images/google.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    PhoneAuthentication(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        " SignUp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
