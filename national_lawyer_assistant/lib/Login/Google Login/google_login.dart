import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googlsSignIn = GoogleSignIn();
  // don't forget to add firebase auth and google sign in package
  Future<String> signInWithGoogle() async {
    String res = "You didn't select an Account";
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googlsSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCredential);
        User user = FirebaseAuth.instance.currentUser!;
        await AuthServices().addUserToFirestore(
            uid: user.uid,
            sign_in_method: FirebaseServices().getSignInMethod(user),
            name: user.displayName,
            email: user.email);
        res = "Login Successfull";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.toString() == 'invalid-email') {
        res = 'Please enter a valid email';
      } else if (e.code.toString() == 'invalid-credential') {
        res = 'Incorrect Provided Credential';
      } else if (e.code == 'network-request-failed') {
        res = 'Check your internet Connection.';
      }
      res = "Firebase Exception : \n" + e.code.toString();
      print(e.code.toString());
    } catch (e) {
      res = e.toString(); // Don't invoke 'print' in production code.
    }
    return res;
  }

  googleSignOut() async {
    await googlsSignIn.signOut();
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
}
