import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:national_lawyer_assistant/Screens/PhoneAuthentication/ui/otp_screen.dart';
import 'package:national_lawyer_assistant/Screens/PhoneAuthentication/bloc/phone_authentication_bloc.dart';
import 'package:national_lawyer_assistant/utils/Widget/button.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/utils/Widget/text_field.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:national_lawyer_assistant/utils/validators.dart';
import 'package:shimmer/shimmer.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({super.key});

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final PhoneAuthenticationBloc phoneAuthenticationBloc =
      PhoneAuthenticationBloc();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String countryCode = '92';

  @override
  void dispose() {
    phoneController.dispose();
    phoneAuthenticationBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    phoneAuthenticationBloc.add(PhoneAuthenticationInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthenticationBloc, PhoneAuthenticationState>(
      bloc: phoneAuthenticationBloc,
      listenWhen: (previous, current) =>
          current is PhoneAuthenticationActionState,
      buildWhen: (previous, current) =>
          current is! PhoneAuthenticationActionState,
      listener: (context, state) {
        if (state is PhoneAuthenticationLoadingActionState) {
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
        } else if (state is PhoneAuthenticationError) {
          Navigator.pop(context);
          showSnackBar(context, state.error, duration: Duration(seconds: 2));
        } else if (state is PhoneAuthenticationToVerifyPhoneNavigationState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                verificationId: state.verificationId.toString(),
                phone: state.phoneNumber.toString(),
              ),
            ),
          );
          print('auth' + state.verificationId);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case PhoneAuthenticationLoaded:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
                title: Text('Phone Authentication',
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
                                                  'Let\'s Get You Verified!',
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
                                    'Verify Phone Number!',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Enter the phone number associated with your account to receive a verification code',
                                    style: TextStyle(
                                      color: onPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: CountryCodePicker(
                                        boxDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: onSecondary,
                                        ),
                                        dialogTextStyle: TextStyle(
                                          color: onPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        dialogSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                          MediaQuery.of(context).size.width * 1,
                                        ),
                                        textStyle: TextStyle(
                                          color: onSecondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        barrierColor: Colors.transparent,
                                        padding: EdgeInsets.all(4),
                                        searchDecoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            borderSide: BorderSide(width: 3),
                                          ),
                                          labelText: "Select Country Code",
                                          hintText: "eg 92",
                                          labelStyle: TextStyle(
                                            color: onPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple,
                                                width: 4),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        initialSelection: 'PK',
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        favorite: ['+92', 'PK', '+1', 'US'],
                                        onChanged: (CountryCode code) {
                                          countryCode =
                                              code.dialCode.toString();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: TextFieldInput(
                                      left: 10,
                                      textEditingController: phoneController,
                                      hintText: 'Phone Number',
                                      icon: Icons.phone,
                                      validator: Validators.validatePhoneNumber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Spacer(),
                              AppButton(
                                onTab: () async {
                                  if (_formKey.currentState!.validate()) {
                                    print(
                                        'Phone Authentication Button Pressed');
                                    phoneAuthenticationBloc
                                        .add(LoadingStateEvent());
                                    try {
                                      await FirebaseAuth.instance
                                          .verifyPhoneNumber(
                                        phoneNumber:
                                            '+${countryCode}${phoneController.text.toString()}',
                                        verificationCompleted:
                                            (phoneAuthCredential) {},
                                        verificationFailed: (error) {
                                          showSnackBar(
                                              context,
                                              'An Error Occured! Please try again later.' +
                                                  error
                                                      .toString()); // Don't invoke 'print' in production code.
                                          Navigator.pop(context);
                                        },
                                        codeSent: (verificationId,
                                            forceResendingToken) {
                                          print("phone auth file" +
                                              verificationId);
                                          // if code is send successfully then navigate to next screen
                                          phoneAuthenticationBloc.add(
                                            PhoneAuthenticationButtonPressedEvent(
                                              phoneNumber:
                                                  '+${countryCode}${phoneController.text.toString()}',
                                              verificationId: verificationId,
                                            ),
                                          );
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verificationId) {},
                                      );
                                    } catch (e) {
                                      showSnackBar(context, e.toString());
                                      print(e.toString());
                                    }
                                  } else {
                                    print('Form is not valid');
                                  }
                                },
                                text: 'Continue',
                              ),
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
