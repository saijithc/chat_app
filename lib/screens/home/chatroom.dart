import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfuncction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/screens/home/chat_tiles.dart';
import 'package:chat_app/screens/search/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods auth = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomsStream;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunction.getUserNameSharedPreference())??'';
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
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.4),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                child: Center(child: Text(Constants.myName)),
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
                HelperFunction.clearUserLoggedInSharedPreference();
                Get.offAll(const Authenticate());
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
      body: chatRoomsStream == null
          ? const Center(child: CircularProgressIndicator())
          : ChatRoomList(chatRoomsStream: chatRoomsStream!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const SearchScreen());
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
