import 'package:chat_app/helper/helperfuncction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/chatroom.dart';
import 'package:chat_app/view/signup.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  // const Signin({Key? key, required this.toggle}) : super(key: key);
  final Function toggle;
  Signin(this.toggle);
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  dynamic snapshotUserInfo;
  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunction.saveUserEmailSharedPreference(emailController.text);
      databaseMethods.getUserByEmail(emailController.text).then((val) {
        snapshotUserInfo = val;
        // HelperFunction.saveUserEmailSharedPreference(
        //     snapshotUserInfo.docs[0].get("name"));
        HelperFunction.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].get("name"));
        // print(
        //     "${snapshotUserInfo.docs[0].get("name")}........heeeeeeeeeyyyyyyyyyy");
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((val) {
        if (val != null) {
          // HelperFunction.saveUserNameSharedPreference(userNameController.text);

          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: text("chat App", Colors.amber, height * 0.03),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "please provide a valid email id";
                      },
                      controller: emailController,
                      style: simpleTextFieldStyle(Colors.white),
                      decoration: textFieldInputDecoration("email")),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val!.length >= 6
                            ? null
                            : "Please should contain minimum 6 characters";
                      },
                      controller: passwordController,
                      style: simpleTextFieldStyle(Colors.white),
                      decoration: textFieldInputDecoration("password")),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text("Forgot password ?", Colors.blue, height * 0.015)
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            InkWell(
              child: Container(
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.blue),
                  width: width,
                  child: Center(
                      child: text("Sign In", Colors.white, height * 0.02))),
              onTap: () {
                signIn();
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              child: Container(
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.white),
                  width: width,
                  child: Center(
                      child: text(
                          "Sign In with Google",
                          const Color.fromARGB(255, 126, 125, 125),
                          height * 0.02))),
              onTap: () {},
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text("Don't have account?", Colors.white, height * 0.02),
                SizedBox(
                  width: width * 0.02,
                ),
                InkWell(
                  child: text("Register now", Colors.blue, height * 0.02),
                  onTap: () {
                    widget.toggle();
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (ctx) =>  SignUp()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
