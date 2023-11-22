import 'dart:developer';

import 'package:chat_app/screens/search/searchlist.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import '../../widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();
  dynamic searchSnapshot;
  initiateSearch() {
    if (searchController.text.isNotEmpty) {
      print("value 1");
      databaseMethods.getUserByName(searchController.text).then((val) {
        setState(() {
          print("searchSnapshot =$val");
          searchSnapshot = val;
        });
      });
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
                                    print("value =$value");
                                    initiateSearch();
                                  },
                                  controller: searchController,
                                  decoration: const InputDecoration(
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
            SizedBox(
                height: height * 0.75,
                child: SearchList(
                  searchSnapshot: searchSnapshot,
                ))
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
