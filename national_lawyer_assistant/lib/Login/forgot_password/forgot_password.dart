import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            dialogBox(context);
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
    );
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
                            Icons.lock,
                            color: Colors.white,
                          ),
                          Text(
                            "Forgot Your Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors
                                  .white, // Optional: set text color to white for better contrast
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              emailController.clear();
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
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      labelText: "Enter the Email",
                      hintText: "eg abc@gmail.com",
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      await auth
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        showSnackBar(context,
                            "We have sent you the reset password link to your email, please check it.");
                      }).onError((error, StackTrace) {
                        showSnackBar(context, error.toString());
                      });
                      Navigator.pop(context);
                      emailController.clear();
                    },
                    child: Text(
                      "Send",
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
