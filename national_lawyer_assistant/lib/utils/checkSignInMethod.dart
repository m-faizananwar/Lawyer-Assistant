import 'package:firebase_auth/firebase_auth.dart';

String checkSignInMethod(User user) {
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
