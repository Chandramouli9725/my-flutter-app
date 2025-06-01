
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance;

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
  fontSize: size.height * 0.060,
  fontWeight: FontWeight.bold,
);

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
  fontSize: size.height * 0.030,
);

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
    Size size,
    ) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.deepPurpleAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
