import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  const Conversation(
      {Key? key,
      required this.chatRoomId,
      required this.userName,
      required this.email})
      : super(key: key);
  // Conversation(this.chatRoomId);
  final String chatRoomId;
  final String userName;
  final String email;
  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatMessageStream;
  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      isSendByMe: snapshot.data.docs[index].data()["sendBy"] ==
                          Constants.myName,
                      message: snapshot.data.docs[index].data()["message"]);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addConversation(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversation(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 192, 192, 192),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 155, 155, 155),
          leading: Padding(
            padding: EdgeInsets.only(left: height * 0.009),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: height * 0.03,
              child: Center(
                  child: Text(widget.userName.substring(0, 1).toUpperCase())),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(widget.userName.toUpperCase(), Colors.white, height * 0.025),
              text(widget.email, const Color.fromARGB(255, 187, 187, 187),
                  height * 0.015)
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: SizedBox(
          child: Stack(
            children: [
              SizedBox(height: height * 0.8, child: chatMessageList()),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ColoredBox(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                  hintText: "Type message",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 143, 143, 143),
                          radius: 20,
                          child: Center(
                              child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.message, required this.isSendByMe})
      : super(key: key);
  final String message;
  final bool isSendByMe;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: width,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [
                        const Color.fromARGB(255, 171, 208, 241),
                        const Color(0xff2A75Bc)
                      ]
                    : [
                        const Color.fromARGB(255, 49, 49, 49),
                        const Color.fromARGB(26, 185, 168, 168)
                      ])),
        child: text(message, Colors.white, height * 0.022),
      ),
    );
  }
}
