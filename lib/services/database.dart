import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseMethods {
  getUserByName(String username) async {
    print("value 2");
    List accounts = [];
    accounts.clear();
    var collection = await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((value) => value.docs);
    print("value 3 collection =$collection");
    for (var user in collection) {
      if (user.get("name").toString().contains(username)) {
        accounts.add(user);
      }
    }

    return accounts;
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  getEmailByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .where("email")
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap, email) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    });
    // FirebaseFirestore.instance
    //     .collection("chatRoom")
    //     .doc(chatRoomId)
    //     .set(email)
    //     .catchError((e) {
    //   Get.snackbar(e.toString(), "",
    //       snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    // });
  }

  addConversation(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      Get.snackbar(e.toString(), "",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    });
  }

  getConversation(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("user", arrayContains: userName)
        .snapshots();
  }
}

// Map a = {
//   "chatroomId": "saijith_thwasim ",
//   "user": ["thwasim", "saijith"],
//   "userEmail": "thwasim@gmail.com "
// };
