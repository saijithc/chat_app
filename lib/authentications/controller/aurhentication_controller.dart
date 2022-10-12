import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/helperfuncction.dart';
import '../../screens/home/chatroom.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class Authentication extends GetxController {
  final signUPformKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;
  bool loading = false;
  dynamic snapshotUserInfo;
  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunction.saveUserEmailSharedPreference(emailController.text);
      databaseMethods.getUserByEmail(emailController.text).then((val) {
        snapshotUserInfo = val;
        HelperFunction.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].get("name"));
      });
      isLoading = true;
      update();
      authMethods
          .signInWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((val) {
        if (val != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Get.offAll(const ChatRoom());
          emailController.clear();
          passwordController.clear();
          userNameController.clear();
        }
      });
    }
  }

  signMeUp() {
    if (signUPformKey.currentState!.validate()) {
      loading = true;
      update();

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((val) {
        Map<String, String> userInfoMap = {
          "name": userNameController.text,
          "email": emailController.text
        };
        HelperFunction.saveUserEmailSharedPreference(emailController.text);
        HelperFunction.saveUserNameSharedPreference(userNameController.text);
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInSharedPreference(true);
        Get.offAll(const ChatRoom());
        emailController.clear();
        passwordController.clear();
      });
    }
  }
}
