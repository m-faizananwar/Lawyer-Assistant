import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:national_lawyer_assistant/Login/Phone%20authentication/otp_screen.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController phoneController = TextEditingController();
  String country_code = '92';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.topLeft,
      width: height / 9,
      height: height / 9.5,
      child: InkWell(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(50), // Adjust the value to set the radius
          child: Image.asset(
            "assets/images/call.png",
            fit: BoxFit.cover, // Ensure the image covers the container
          ),
        ),
        onTap: () {
          dialogBox(context);
          // Define the action to be taken when the image is tapped
        },
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void dialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Set the background color to blue
                      borderRadius: BorderRadius.circular(20), // Curved edges
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Optional: add some padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          Text(
                            "Phone Authentication",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors
                                  .white, // Optional: set text color to white for better contrast
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                            color: Colors
                                .white, // Optional: set icon color to white for better contrast
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(30)),
                        child: CountryCodePicker(
                          boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white24),
                          dialogTextStyle: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          dialogSize: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.width * 1),
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          barrierColor: Colors.transparent,
                          padding: EdgeInsets.all(4),
                          searchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(width: 3)),
                            labelText: "Select Country Code",
                            hintText: "eg 92",
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 4),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          initialSelection: 'PK',
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          favorite: [
                            '+92',
                            'PK',
                            '+1',
                            'US',
                          ],
                          onChanged: (CountryCode countryCode) {
                            // Update the phone number prefix based on the selected country code
                            country_code = countryCode.dialCode.toString();
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                10), // Limits to 6 digits
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only digits
                          ],
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            labelText: "Enter the Phone Number",
                            hintText: "eg 3214887082",
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            print(
                                "+${country_code}${phoneController.text.toString()}");
                            try {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '+${country_code}${phoneController.text.toString()}',
                                verificationCompleted: (phoneAuthCredential) {},
                                verificationFailed: (error) {
                                  showSnackBar(
                                      context,
                                      error
                                          .toString()); // Don't invoke 'print' in production code.
                                },
                                codeSent:
                                    (verificationId, forceResendingToken) {
                                  setState(() {
                                    isLoading = false;
                                    print("sent");
                                  });
                                  // if code is send successfully then navigate to next screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                        verificationId: verificationId,
                                        phone:
                                            '+${country_code}${phoneController.text.toString()}',
                                      ),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout: (verificationId) {},
                              );
                            } catch (e) {
                              showSnackBar(context, e.toString());
                            }
                          },
                          child: Text(
                            "Send OTP",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }
}
