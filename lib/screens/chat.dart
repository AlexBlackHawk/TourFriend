import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/widgets/message_item.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class Chat extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String chatRoomId;
  const Chat({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.chatRoomId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatInputController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  Map<String, dynamic>? chatRoom;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    setState(() async {
      chatRoom = await widget.database.getChatRoomInfo(widget.chatRoomId);
      chats = widget.chat.getChats(widget.chatRoomId);
      for (var i = 0; i < chatRoom!["users"].length; i++){
        if (chatRoom!["users"][i] != widget.auth.user!.uid) {
          userData = await widget.database.getUserInfo(chatRoom!["users"][i]);
        }
      }
    });
  }

  @override
  void dispose() {
    chatInputController.dispose();
    super.dispose();
  }

  // handle send message
  void handleSendMessage() {
    if (chatInputController.text.isNotEmpty) {
      String id = widget.auth.user!.uid;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": id,
        "message": chatInputController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      widget.chat.addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        chatInputController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chats != null) {
      return Scaffold(
        appBar: getAppBar(),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            messagesList(),
            bottomTextBox(),
          ],
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(),
      );
    }
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlue,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.black,),
              ),
              const SizedBox(width: 2,),
              CircleAvatar(
                backgroundImage: NetworkImage(userData!["avatar"]),
                maxRadius: 20,
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(userData!["name"],style: const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messagesList() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            bool sendByMe = widget.auth.user!.uid == snapshot.data!.docs[index]["sendBy"];
            return MessageItem(
              auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,
              message: snapshot.data!.docs[index]["message"],
              senderMe: sendByMe,
              photo: sendByMe ? null : userData!["avatar"],
            );
          },
        )
            : Container();
      },
    );
  }

  Align bottomTextBox() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            // GestureDetector(
            //   onTap: (){
            //   },
            //   child: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlue,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: const Icon(Icons.add, color: Colors.white, size: 20, ),
            //   ),
            // ),
            const SizedBox(width: 15,),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            const SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: () {
                handleSendMessage();
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(Icons.send,color: Colors.white,size: 18,),
            ),
          ],

        ),
      ),
    );
  }
}