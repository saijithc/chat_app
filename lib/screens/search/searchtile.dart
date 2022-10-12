import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'create_chatroom.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({Key? key, required this.userName, required this.userEmail})
      : super(key: key);
  final String userName;
  final String userEmail;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
                  title: text(userName, Colors.white, h * 0.021),
                  subtitle: text(
                    userEmail,
                    Colors.white54,
                    h * 0.015,
                  ),
                  trailing: ElevatedButton(
                      onPressed: () {
                        createChatRoom(context,
                            userName: userName, userEmail: userEmail);
                      },
                      child: text("Message", Colors.white, h * 0.014)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
