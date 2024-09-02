import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(
      {required String email,
      required String password,
      required String name}) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user!.updateDisplayName(name);
        res = "Registration Successful";
      } else {
        res = "Please fill all details.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res =
            'Password provided is too weak. At least 6 characters are required.';
      } else if (e.code == 'email-already-in-use') {
        res = 'Email provided already exists';
      } else if (e.code == 'invalid-email') {
        res = 'Please enter a valid email';
      } else if (e.code == 'network-request-failed') {
        res = 'Check your internet Connection.';
      }
      res = "Firebase Exception : \n" + e.code.toString();
      print(e.code.toString());
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> addUserToFirestore({
    required String sign_in_method,
    required String uid,
    String? email,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'sign_in_method': sign_in_method,
          'name': name,
          'email': email,
          'uid': uid,
          'Phone Number': phoneNumber,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> logIn(
      {required String email, required String password}) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Login Successfull";
      } else if (email.isEmpty) {
        res = "Please enter your email";
      } else if (password.isEmpty) {
        res = "Please enter your password";
      } else {
        res = "Please enter both email and password";
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
      res = e.toString();
    }
    return res;
  }

  Future<String> updateData({
    required String sign_in_method,
    required String uid,
    String? email,
    String? name,
    String? phoneNumber,
  }) async {
    String res = "Some Error Occured";
    try {
      final Map<String, dynamic> dataToUpdate = {
        'sign_in_method': sign_in_method,
        'uid': uid,
      };

      if (name != null) {
        dataToUpdate['name'] = name;
      }
      if (email != null) {
        dataToUpdate['email'] = email;
      }
      if (phoneNumber != null) {
        dataToUpdate['Phone Number'] = phoneNumber;
      }

      await _firestore.collection("users").doc(uid).update(dataToUpdate);
      res = "Data Updated";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
