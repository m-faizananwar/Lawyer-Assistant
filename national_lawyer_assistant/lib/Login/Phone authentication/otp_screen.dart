import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/google_login.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/home.dart';
import 'package:national_lawyer_assistant/splash.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  // we have also add the circular progressIndicator during waiting time
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode ? "assets/images/Logo_dark.png" : "assets/images/Logo_bright.png";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.asset(
                    logoAsset,
                  ),
                ),
              ),
              const Text(
                "OTP Verification",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "We need to register your phone number by using a one-time OTP code verification.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PinCodeTextField(
                  textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.transparent,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    print("Completed : $v");
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpController.text,
                      );
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      User user = FirebaseAuth.instance.currentUser!;
                      await AuthServices().addUserToFirestore(uid: user.uid, sign_in_method: FirebaseServices().getSignInMethod(user), phoneNumber: user.phoneNumber);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } catch (e) {
                      showSnackBar(context, e.toString());
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onChanged: (value) {
                    print("Changed $value");
                  },
                  beforeTextPaste: (text) {
                    // Allows pasting the OTP code
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text,
                          );
                          await FirebaseAuth.instance.signInWithCredential(credential);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );
                        } catch (e) {
                          showSnackBar(context, e.toString());
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text(
                        "Send Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
