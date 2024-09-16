import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:national_lawyer_assistant/Screens/forgetPassword/bloc/forget_password_bloc.dart';
import 'package:national_lawyer_assistant/utils/Widget/button.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/utils/Widget/text_field.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:national_lawyer_assistant/utils/validators.dart';
import 'package:shimmer/shimmer.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final ForgetPasswordBloc forgetPasswordBloc = ForgetPasswordBloc();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    forgetPasswordBloc.add(ForgetPasswordInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      bloc: forgetPasswordBloc,
      listenWhen: (previous, current) => current is ForgetPasswordActionState,
      buildWhen: (previous, current) => current is! ForgetPasswordActionState,
      listener: (context, state) {
        if (state is ForgetPasswordLoading) {
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
        } else if (state is ForgetPasswordError) {
          Navigator.pop(context);
          showSnackBar(context, state.message, duration: Duration(seconds: 2));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ForgetPasswordLoaded:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
                title: Text('Forget Password',
                    style: TextStyle(color: onSecondary)),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: onSecondary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  // Adjust the bottom padding to prevent the overlay issue
                  double bottomPadding =
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? 0
                          : MediaQuery.of(context).viewInsets.bottom - 16;

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: primary,
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // Optional: Background color if the image is transparent
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/ErrorImage.png',
                                              fit: BoxFit.cover,
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
                                                  'Let\'s Get You Back In!',
                                                  style: TextStyle(
                                                      color: onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: ListTile(
                                  title: Text(
                                    'Find Your Account!',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Enter the email associated with your account to change your password',
                                    style: TextStyle(
                                      color: onPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFieldInput(
                                textEditingController: emailController,
                                hintText: 'Email',
                                icon: Icons.email,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 20),
                              AppButton(
                                onTab: () {
                                  if (_formKey.currentState!.validate()) {
                                    print('Forget Password Button Pressed');
                                    forgetPasswordBloc.add(
                                        ForgetPasswordButtonPressedEvent(
                                            email: emailController.text));
                                    // Trigger your forget password event here
                                    // forgetPasswordBloc.add(YourForgetPasswordEvent(emailController.text));
                                  } else {
                                    print('Form is not valid');
                                  }
                                },
                                text: 'Continue',
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );

          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
