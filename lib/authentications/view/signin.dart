import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/aurhentication_controller.dart';

class Signin extends StatelessWidget {
  Signin({Key? key, required this.toggle}) : super(key: key);
  final Authentication controller = Get.put(Authentication());
  final Function toggle;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: text("chat App", Colors.white, height * 0.03),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: controller.formKey,
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
                      controller: controller.emailController,
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
                      controller: controller.passwordController,
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
                controller.signIn();
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
                    toggle();
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
