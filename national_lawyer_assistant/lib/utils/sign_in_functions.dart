import 'package:firebase_auth/firebase_auth.dart';
import 'package:national_lawyer_assistant/utils/Services/google_login.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';

class LoginFunctions {
  static Future<String> logInUser(String email, String password) async {
    String res = await AuthServices().logIn(
      email: email,
      password: password,
    );

    return res;
  }

  static Future<String> googleLogInUser() async {
    String res = await FirebaseServices().signInWithGoogle();
    return res;
  }

  static Future<String> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "We have sent you the reset password link to your email, please check it.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpUser(String name, String email, String password) async {
    String res = await AuthServices().signUp(
      email: email,
      password: password,
      name: name,
    );
    return res;
  }

  static Future<List<String>> verifyPhoneNumber(String phoneNumber) async {
    List<String> list = [];
    try {
      // Variable to hold the verification result
      String resultMessage = "Verification failed";
      String verificationId = "";

      // Trigger the phone number verification process
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$phoneNumber',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          // Handle auto-completion of verification (e.g., auto-retrieval)
          resultMessage = "Verification completed automatically";
        },
        verificationFailed: (FirebaseAuthException error) {
          // Handle any errors that occur during verification
          resultMessage = "Verification failed: ${error.message}";
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          // Handle successful code sent
          resultMessage = "OTP sent successfully";
          verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
          resultMessage = "Verification timeout. Please try again.";
        },
      );
      list.add(resultMessage);
      if (verificationId.isNotEmpty) {
        list.add(verificationId);
      }
      // Return the result message
      return list;
    } catch (e) {
      list.add("Error occurred: ${e.toString()}");
      // Return error message in case of an exception
      return list;
    }
  }

  static String checkSignInMethod(User user) {
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
}
