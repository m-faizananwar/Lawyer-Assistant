import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/google_login.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/verify_email.dart';
import 'package:national_lawyer_assistant/Login/Phone%20authentication/phone_authentication.dart';
import 'package:national_lawyer_assistant/Login/Screens/sign_up.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';
import 'package:national_lawyer_assistant/Login/Widget/button.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/Login/Widget/text_field.dart';
import 'package:national_lawyer_assistant/Login/forgot_password/forgot_password.dart';
import 'package:national_lawyer_assistant/Screens/Login/bloc/login_bloc.dart';
import 'package:national_lawyer_assistant/splash.dart';
import 'package:national_lawyer_assistant/utils/validators.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc loginPageBloc = LoginBloc();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginPageBloc.add(LoginInitialEvent());
    print('InitState');
  }

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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final String logoAsset = isDarkMode
        ? "assets/images/Logo_dark.png"
        : "assets/images/Logo_bright.png";
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer(
        bloc: loginPageBloc,
        buildWhen: (previous, current) => current is! LoginActionState,
        listenWhen: (previous, current) => current is LoginActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginLoading:
              return Scaffold(
                backgroundColor: Colors.purple[900],
                body: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.purple[500],
                      strokeWidth: 5,
                    ),
                  ),
                ),
              );
            case LoginSuccess:
              return Scaffold(
                backgroundColor: Colors.deepPurple[100],
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        height: height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.purple[900],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: height / 5,
                                        width: height / 5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[
                                              200], // Optional: Background color if the image is transparent
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/ChatBotLogo.png',
                                            fit: BoxFit
                                                .cover, // Ensures the image fits inside the container
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Shimmer.fromColors(
                                          direction: ShimmerDirection.ltr,
                                          baseColor: Colors.white,
                                          highlightColor: Colors.purple[200]!,
                                          child: Column(
                                            children: [
                                              Text(
                                                'I\'m your Assistant',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    letterSpacing: 1.2,
                                                    fontFamily: 'Suse'),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextFieldInput(
                              textEditingController: emailController,
                              hintText: "Enter Email",
                              icon: Icons.email,
                              validator: Validators.validateEmail,
                            ),
                            TextFieldInput(
                              textEditingController: passwordController,
                              hintText: "Enter Password",
                              icon: Icons.lock,
                              isPass: true,
                              validator: Validators.validatePassword,
                            ),
                            ForgotPassword(),
                            AppButton(
                                onTab: () {
                                  if (_formKey.currentState!.validate()) {
                                    print('form is valid');
                                    logInUser();
                                  } else {
                                    print("Form is not valid");
                                  }
                                },
                                text: "Log in"),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          height: 1, color: secondary)),
                                  Text(
                                    " OR CONTINUE WITH ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                          height: 1, color: secondary)),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " SignUp",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                ),
              );
            case LoginFailure:
              return Scaffold(
                backgroundColor: Colors.purple[900],
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[
                              200], // Optional: Background color if the image is transparent
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/ErrorImage.png',
                            fit: BoxFit
                                .cover, // Ensures the image fits inside the container
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Welcome Dear!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      SizedBox(height: 150),
                      Text(
                        (state as LoginFailure).error,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.purple[500],
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.purple[500],
                      strokeWidth: 5,
                    ),
                  ),
                ),
              );
          }
        },
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            );
          } else if (state is LoginFailure) {
            showSnackBar(context, state.error);
          } else if (state is LoginToVerifyEmailNavigationState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VerifyEmailPage(),
              ),
            );
          } else if (state is LoginToForgotPasswordNavigationState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ForgotPassword(),
              ),
            );
          } else if (state is LoginToPhoneNavigationState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PhoneAuthentication(),
              ),
            );
          } else if (state is LoginToSignUpNavigationState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ),
            );
          }
        });
  }
}
