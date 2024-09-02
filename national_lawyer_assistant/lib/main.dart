import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/Login/Google%20Login/verify_email.dart';
import 'package:national_lawyer_assistant/Screens/splashScreen/ui/splash_screen.dart';
// import 'package:national_lawyer_assistant/splash.dart';

import 'Login/Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAHkwvFqhaXCGFHi_1mLQ1foZYPtBL3WM8",
      appId: "1:688748519776:android:975f8d2e744b9cf7a73e05",
      messagingSenderId: "688748519776",
      projectId: "national-lawyer-assistant",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User? user = FirebaseAuth.instance.currentUser;

          // String signInMethod = "Unknown";
          // if (user != null) {
          //   for (var userInfo in user.providerData) {
          //     switch (userInfo.providerId) {
          //       case 'google.com':
          //         signInMethod = "Google Sign-In";
          //         break;
          //       case 'password':
          //         signInMethod = "Email/Password Sign-In";
          //         break;
          //       case 'phone':
          //         signInMethod = "Phone Sign-In";
          //         break;
          //     }
          //   }
          // }

          if (snapshot.connectionState == ConnectionState.active) {
            return SplashScreen();
            // if (snapshot.hasData) {
            //   if (signInMethod == "Phone Sign-In") {
            //     return SplashScreen();
            //   } else if (!(user?.emailVerified ?? true)) {
            //     print("verify");
            //     return SplashScreen();
            //     // return SplashScreen(widget: VerifyEmailPage());
            //   } else if (user?.emailVerified ?? false) {
            //     print("verified");
            //     return SplashScreen();
            //   } else {
            //     print("Login");
            //     return SplashScreen();
            //     // return SplashScreen(widget: LoginPage());
            //   }
            // } else {
            //   print("1235");
            //   //  return SplashScreen(widget: LoginPage());
            //   return SplashScreen();
            // }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          surface: Colors.deepPurple[100]!,
          primary: Colors.grey[300]!,
          onPrimary: Colors.grey[400]!,
          secondary: Colors.black!,
          onSecondary: Colors.grey[600]!,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          surface: Color.fromARGB(255, 0, 0, 0),
          primary: Colors.grey[900]!,
          onPrimary: Colors.grey[800]!,
          secondary: Colors.white,
          onSecondary: Colors.grey[600]!,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
