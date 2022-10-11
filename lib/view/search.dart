import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/conversion_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();

  dynamic searchSnapshot;
  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.length,
            itemBuilder: (context, index) {
              return searchTile(
                  userName: searchSnapshot![index].get("name"),
                  userEmail: searchSnapshot![index].get("email"));
            },
          )
        : Container();
  }

  initiateSearch() {
    if (searchController.text.isNotEmpty) {
      databaseMethods.getUserByName(searchController.text).then((val) {
        setState(() {
          searchSnapshot = val;
        });
      });
    }
  }

  Widget searchTile({required String userName, required String userEmail}) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ColoredBox(
                color: const Color.fromARGB(255, 36, 35, 35),
                child: ListTile(
                  title: text(userName, Colors.white, height * 0.021),
                  subtitle: text(
                    userEmail,
                    Colors.white54,
                    height * 0.015,
                  ),
                  trailing: ElevatedButton(
                      onPressed: () {
                        createChatRoom(
                            userName: userName, userEmail: userEmail);
                      },
                      child: text("Message", Colors.white, height * 0.014)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  //---------------create chatroom--send user conversation screen---------

  createChatRoom({String? userName, userEmail}) {
    if (userName != Constants.myName) {
      String chatroomId = getChatRoomId(userName!, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "user": users,
        "chatroomId": chatroomId,
        "userEmail": userEmail.toString()
      };
      DatabaseMethods().createChatRoom(chatroomId, chatRoomMap, userEmail);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => Conversation(
                chatRoomId: chatroomId,
                userName: userName,
                email: userEmail.toString(),
              )));
    } else {
      Get.snackbar("you cant send message to yourself", "",
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1));
      //print("you cant send message to yourself");

    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: text("search", Colors.white, height * 0.03),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: const Color.fromARGB(255, 80, 80, 79),
                  height: height * 0.075,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: height * 0.005),
                            child: Center(
                              child: TextField(
                                  onChanged: (value) {
                                    initiateSearch();
                                  },
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                      // suffixIcon: IconButton(
                                      //     onPressed: () {
                                      //       // initiateSearch();
                                      //     },
                                      //     icon: const Icon(Icons.search)),

                                      hintText: "search username",
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                      border: InputBorder.none)),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.75, child: searchList())
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
