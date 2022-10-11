import 'package:chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User user) {
    //  user = _auth.currentUser;
    // ignore: unnecessary_null_comparison
    return user != null ? Users(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = (await _auth.signInWithEmailAndPassword(
          email: email, password: password));
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      // print(e.toString());
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }

  Future reserPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }
}
