import 'dart:developer';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/home/chats.dart';
import 'package:flutter/material.dart';

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({Key? key, required this.chatRoomsStream})
      : super(key: key);
  final Stream chatRoomsStream;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  log(snapshot.data.docs[index]
                      .data()["chatroomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""));
                  return ChatRoomTile(
                      email: snapshot.data.docs[index].data()["userEmail"],
                      userName: snapshot.data.docs[index]
                          .data()["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRooomId:
                          snapshot.data.docs[index].data()["chatroomId"]);
                })
            : Container();
      },
    );
  }
}
