import 'dart:developer';

import 'package:chat_app/helper/helperfuncction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/chatroom.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  // const SignUp({Key? key, this.toggle}) : super(key: key);
  // final Function? toggle;.
  SignUp(this.toggle);
  final Function toggle;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const ChatRoom()));
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
        child: isLoading
            ? Container(
                child: const Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.2,
                          ),
                          TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 4
                                    ? "Please provide Username"
                                    : null;
                              },
                              controller: userNameController,
                              style: simpleTextFieldStyle(Colors.white),
                              decoration: textFieldInputDecoration("username")),
                          SizedBox(height: height * 0.03),
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
                          SizedBox(height: height * 0.03),
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
                              child: text(
                                  "Sign Up", Colors.white, height * 0.02))),
                      onTap: () {
                        signMeUp();
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
                                  "Sign Up with Google",
                                  const Color.fromARGB(255, 126, 125, 125),
                                  height * 0.02))),
                      onTap: () {},
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text("Already have account?", Colors.white,
                            height * 0.02),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        GestureDetector(
                          child: text("SignIn now", Colors.blue, height * 0.02),
                          onTap: () {
                            widget.toggle();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
