import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants.dart';
import 'package:my_flutter_app/screens/login_screen.dart';
import 'package:my_flutter_app/screens/project_screen.dart';
import 'package:my_flutter_app/services/database_services.dart';

class AuthServices {
  Future login(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProjectScreen()),
        (route) => false,
      );
    } catch (e) {
      print('error while logging in $e');
      return e;
    }
  }

  Future signUp(
    String username,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null) {
        await DBServices().createOrUpdateDocument('users/${user.user?.uid}', {
          'uid': user.user?.uid,
          'displayName': username,
          'timeStamp': Timestamp.now(),
        });
        if (Navigator.canPop(context)) Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProjectScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('error while logging in $e');
      return e;
    }
  }

  blockScreen(BuildContext context) {
    showDialog(
      // barrierColor: Colors.grey.shade200,
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const PopScope(
            canPop: false,
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }

  /// Get FirebaseAuthException Error Messages

  String getFirebaseAuthExceptionErrorMessages(String code) {
    if (code == 'account-exists-with-different-credential') {
      return 'The account for the given credential already exists';
    } else if (code == 'invalid-credential') {
      return 'The provided credential is invalid';
    } else if (code == 'operation-not-allowed') {
      return 'The operation is not allowed';
    } else if (code == 'user-disabled') {
      return 'The user is disabled. Please try again later or contact support';
    } else if (code == 'user-not-found') {
      return 'The provided user is not found';
    } else if (code == 'wrong-password') {
      return 'The provided password is invalid';
    } else if (code == 'invalid-verification-code') {
      return 'The provided verification code is invalid';
    } else if (code == 'invalid-verification-id') {
      return 'The provided verification id is invalid';
    } else {
      debugPrint('the detailed error is $code');
      return 'An error occurred. Please try again later or contact support';
    }
  }

  logout(BuildContext context) async {
    AuthServices().blockScreen(context);
    await auth.signOut();
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
