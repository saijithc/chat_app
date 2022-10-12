import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/database.dart';
import '../conversation/conversion_screen.dart';

createChatRoom(BuildContext context, {String? userName, userEmail}) {
  if (userName != Constants.myName) {
    String chatroomId = getChatRoomId(userName!, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "user": users,
      "chatroomId": chatroomId,
      "userEmail": userEmail.toString()
    };
    DatabaseMethods().createChatRoom(chatroomId, chatRoomMap, userEmail);
    Get.to(Conversation(
        chatRoomId: chatroomId,
        userName: userName,
        email: userEmail.toString()));
  } else {
    Get.snackbar("you cant send message to yourself", "",
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1));
    //print("you cant send message to yourself");

  }
}
