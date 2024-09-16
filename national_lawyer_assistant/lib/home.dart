import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';
import 'package:national_lawyer_assistant/chatbot.dart';
import 'package:national_lawyer_assistant/utils/Widget/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  String signInMethod = "Unknown";

  @override
  void initState() {
    super.initState();

    signInMethod = getSignInMethod(user);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = user.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (signInMethod == "Phone Sign-In" &&
          userDoc.exists &&
          userDoc.data()?['name'] == null) {
        dialogBox(context);
      } else {
        final userName = userDoc.data()?['name'] ?? 'User';
        showSnackBarBlue(context, "Welcome to LaxiPAK, $userName.",
            duration: Duration(milliseconds: 1000), bottom: 100);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(),
    );
  }

  String getSignInMethod(User? user) {
    String signInMethod = "Unknown";

    if (user != null) {
      for (var userInfo in user.providerData) {
        switch (userInfo.providerId) {
          case 'google.com':
            signInMethod = "Google Sign-In";
            break;
          case 'password':
            signInMethod = "Email/Password Sign-In";
            break;
          case 'phone':
            signInMethod = "Phone Sign-In";
            break;
        }
      }
    }

    return signInMethod;
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
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        Text(
                          "Enter Your name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            nameController.clear();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    labelText: "Enter your name",
                    hintText: "Allison Burgurs",
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    String res = await AuthServices().updateData(
                      sign_in_method: "Phone Sign-In",
                      uid: user.uid,
                      name: nameController.text,
                    );
                    (res == "Data Updated")
                        ? showSnackBarBlue(context, res)
                        : showSnackBar(context, res);
                    Navigator.pop(context);
                    nameController.clear();
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
      },
    );
  }
}
