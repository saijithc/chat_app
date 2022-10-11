import 'dart:developer';

import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfuncction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/conversion_screen.dart';
import 'package:chat_app/view/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods auth = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      // initialData: initialData,
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

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunction.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //   final width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.4),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                child: Center(child: Text(Constants.myName)
                    // text(constants.myName.toUpperCase(), Colors.white, "")
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: () {
                auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const Authenticate()));
              },
              leading: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              title:
                  const Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        title: text("chats", Colors.white, height * 0.02),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

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
    //final width = MediaQuery.of(context).size.width;
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => Conversation(
                            chatRoomId: chatRooomId,
                            userName: userName,
                            email: email)));
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
