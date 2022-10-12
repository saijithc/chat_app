import 'package:chat_app/services/database.dart';
import 'package:chat_app/screens/conversation/conversion_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile(
      {Key? key,
      required this.userName,
      required this.chatRooomId,
      required this.email})
      : super(key: key);
  final String userName;
  final String email;
  final String chatRooomId;
  final DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: userName.isNotEmpty
              ? ListTile(
                  onTap: () {
                    Get.to(Conversation(
                        chatRoomId: chatRooomId,
                        userName: userName,
                        email: email));
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    child: Center(
                        child: Text(userName.substring(0, 1).toUpperCase())),
                  ),
                  title: text(userName, Colors.black, height * 0.02),
                )
              : Center(
                  child: Container(
                      color: Colors.amber,
                      height: height,
                      child: Center(
                          child: text("Find your Friends", Colors.white,
                              height * 0.06))),
                ),
        ),
      ),
    );
  }
}
