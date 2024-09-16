import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:national_lawyer_assistant/utils/Services/google_login.dart';
import 'package:national_lawyer_assistant/Screens/signup/ui/verify_email.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';

import 'package:national_lawyer_assistant/Screens/Login/bloc/login_bloc.dart';
import 'package:national_lawyer_assistant/Screens/PhoneAuthentication/ui/phone_auth.dart';
import 'package:national_lawyer_assistant/Screens/forgetPassword/ui/forget_password.dart';
import 'package:national_lawyer_assistant/Screens/signup/ui/sign_up.dart';
import 'package:national_lawyer_assistant/Screens/splashScreen/ui/splash_screen.dart';
import 'package:national_lawyer_assistant/utils/Widget/button.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/utils/Widget/text_field.dart';
import 'package:national_lawyer_assistant/utils/const.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginPageBloc.add(LoginInitialEvent());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String logoAsset = 'assets/images/ChatBotLogo.png';
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer(
      bloc: loginPageBloc,
      buildWhen: (previous, current) => current is! LoginActionState,
      listenWhen: (previous, current) => current is LoginActionState,
      listener: (context, state) {
        if (state is LoginToVerifyEmailNavigationState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VerifyEmailPage(),
            ),
          );
        } else if (state is LoginToForgotPasswordNavigationState) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ForgetPasswordPage()));
        } else if (state is LoginToPhoneNavigationState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhoneAuthenticationPage(),
            ),
          );
        } else if (state is LoginToSignUpNavigationState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignUpPage(),
            ),
          );
        } else if (state is LoginToSplashNavigationState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          );
        } else if (state is LoginLoadingActionState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: onSecondary,
                          color: purple500,
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is LoginFailure) {
          Navigator.pop(context);
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginLoading:
            return Scaffold(
              backgroundColor: primary,
              body: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: onSecondary,
                    color: purple500,
                    strokeWidth: 5,
                  ),
                ),
              ),
            );
          case LoginSuccess:
            return Scaffold(
              appBar: AppBar(
                title: Container(),
                backgroundColor: primary,
              ),
              backgroundColor: surface,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(150),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: height / 6,
                                    width: height / 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
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
                                      baseColor: onSecondary,
                                      highlightColor: purple200,
                                      child: Column(
                                        children: [
                                          Text(
                                            'I\'m your Assistant',
                                            style: TextStyle(
                                                color: onSecondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
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
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                validator: Validators.validatePassword,
                                isPass: true,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                loginPageBloc.add(
                                    LoginToForgotPasswordNavigationEvent());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.purple[700]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        AppButton(
                            onTab: () {
                              if (_formKey.currentState!.validate()) {
                                print('Form Valid!');
                                loginPageBloc.add(LoginWithPasswordEvent(
                                    email: emailController.text,
                                    password: passwordController.text));
                              } else {
                                print('Form Invalid');
                              }
                            },
                            text: "Log in"),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Container(height: 1, color: secondary)),
                              Text(
                                " OR CONTINUE WITH ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primary,
                                ),
                              ),
                              Expanded(
                                  child:
                                      Container(height: 1, color: secondary)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.topLeft,
                              width: height / 9,
                              height: height / 9.5,
                              child: InkWell(
                                onTap: () {
                                  loginPageBloc.add(LoginWithGoogleEvent());
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
                            Container(
                              alignment: Alignment.topLeft,
                              width: height / 9,
                              height: height / 9.5,
                              child: InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      50), // Adjust the value to set the radius
                                  child: Image.asset(
                                    "assets/images/call.png",
                                    fit: BoxFit
                                        .cover, // Ensure the image covers the container
                                  ),
                                ),
                                onTap: () {
                                  loginPageBloc.add(LoginWithPhoneEvent());
                                  // Define the action to be taken when the image is tapped
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 20,
                                color: onPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                loginPageBloc
                                    .add(LoginToSignUpNavigationEvent());
                              },
                              child: Text(
                                " SignUp",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.blue[900],
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

          default:
            return Scaffold(
              backgroundColor: primary,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                      "An Unknown Exception Occured.Try Again Later",
                      style: TextStyle(
                        color: onSecondary,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: onSecondary,
                          color: purple500,
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
