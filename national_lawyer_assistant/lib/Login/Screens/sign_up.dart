import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/verify_email.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/Login/Widget/text_field.dart';

import '../Widget/button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    String res = await AuthServices().signUp(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    if (res == "Registration Successful") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(),
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

    double height = MediaQuery.of(context).size.height;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
        ? "assets/images/Logo_dark.png"
        : "assets/images/Logo_bright.png";

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: height / 3,
                    child: Image.asset(
                      logoAsset,
                    ),
                  ),
                ),
                TextFieldInput(
                  textEditingController: nameController,
                  hintText: "Enter your name",
                  icon: Icons.person,
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
                AppButton(onTab: signUpUser, text: "Sign Up"),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
