import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:national_lawyer_assistant/Screens/signup/ui/verify_email.dart';
import 'package:national_lawyer_assistant/Screens/signup/bloc/signup_bloc.dart';
import 'package:national_lawyer_assistant/Screens/Login/ui/login.dart';
import 'package:national_lawyer_assistant/utils/Widget/button.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/utils/Widget/text_field.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:national_lawyer_assistant/utils/validators.dart';
import 'package:shimmer/shimmer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignupBloc signupBloc = SignupBloc();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool agreeToTermsAndServices = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    signupBloc.add(SignupInitialEvent());
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password Required!';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<SignupBloc, SignupState>(
      bloc: signupBloc,
      listenWhen: (previous, current) => current is SignUpActionState,
      buildWhen: (previous, current) => current is! SignUpActionState,
      listener: (context, state) {
        if (state is SignupToLogin) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (state is SignupLoadingError) {
          Navigator.of(context).pop();
          showSnackBar(context, state.error, duration: Duration(seconds: 2));
        } else if (state is SignupLoading) {
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
        } else if (state is SignUpToVerifyEmail) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VerifyEmailPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case SignupLoaded:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
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
                                        highlightColor: purple200!,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Let\' get started!',
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
                          TextFieldInput(
                            hintText: 'First Name',
                            textEditingController: firstNameController,
                            validator: Validators.validateFirstName,
                          ),
                          TextFieldInput(
                            hintText: 'Last Name',
                            textEditingController: lastNameController,
                          ),
                          TextFieldInput(
                            hintText: 'Email',
                            textEditingController: emailController,
                            validator: Validators.validateEmail,
                          ),
                          TextFieldInput(
                            hintText: 'Password',
                            textEditingController: passwordController,
                            isPass: true,
                            validator: Validators.validatePassword,
                          ),
                          TextFieldInput(
                            hintText: 'Confirm Password',
                            textEditingController: confirmPasswordController,
                            isPass: true,
                            validator: _validateConfirmPassword,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  checkColor: onSecondary,
                                  activeColor: Colors.orange[800],
                                  value: agreeToTermsAndServices,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agreeToTermsAndServices = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'I have read and agree to the ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(
                                            color: Colors.orange[800],
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '. By agreeing, you confirm your understanding and acceptance of our End User License Agreement (EULA), ensuring a respectful and secure community experience free from objectionable content and abusive behavior.',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            onTab: () {
                              if (_formKey.currentState!.validate()) {
                                if (agreeToTermsAndServices) {
                                  signupBloc.add(
                                    SignupButtonPressedEvent(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                  // Submit the form
                                  print('Form is valid');
                                } else {
                                  showSnackBar(context,
                                      'You must agree to the Terms and Conditions to continue.');
                                }
                              } else {
                                print('Form is not valid');
                              }
                            },
                            text: 'Continue',
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                        color: onPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signupBloc.add(SignupToLoginEvent());
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.purple[700],
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          case SignupLoadingError:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sign Up Error'),
              ),
              body: const Center(
                child: Text('Error'),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sign Up'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
