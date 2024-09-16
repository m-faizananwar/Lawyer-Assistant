import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/utils/Services/google_login.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';
import 'package:national_lawyer_assistant/Screens/splashScreen/ui/splash_screen.dart';
import 'package:national_lawyer_assistant/home.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shimmer/shimmer.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  const OTPScreen(
      {super.key, required this.verificationId, required this.phone});

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
    final String logoAsset = isDarkMode
        ? "assets/images/Logo_dark.png"
        : "assets/images/Logo_bright.png";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: const Text(
          "OTP Verification",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.height / 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[
                                200], // Optional: Background color if the image is transparent
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
                            baseColor: Colors.white,
                            highlightColor: Colors.purple[200]!,
                            child: Column(
                              children: [
                                Text(
                                  'Let\'s Get You Verified!',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
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
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
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
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      User user = FirebaseAuth.instance.currentUser!;
                      await AuthServices().addUserToFirestore(
                          uid: user.uid,
                          sign_in_method:
                              FirebaseServices().getSignInMethod(user),
                          phoneNumber: user.phoneNumber);
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () async {
                        print("otp file1" + widget.verificationId);

                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text,
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
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
                        print("otp file2" + widget.verificationId);
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
