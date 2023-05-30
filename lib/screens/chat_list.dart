import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_list_item.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'package:intl/intl.dart' as intl;

class ChatList extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const ChatList({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Stream<QuerySnapshot> chatRooms;

  @override
  void initState() {
    super.initState();
    chatRooms = widget.chat.getUserChats(widget.auth.user!.uid);
  }

  String getTime (DateTime dateTime) {
    return intl.DateFormat.Hm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Чати"),
          automaticallyImplyLeading: false,
        ),
        //backgroundColor: Colors[],
        body: StreamBuilder<QuerySnapshot>(
          stream: chatRooms,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ChatListItem(
                  auth: widget.auth,
                  chat: widget.chat,
                  storage: widget.storage,
                  database: widget.database,
                  users: snapshot.data!.docs[index]["users"],
                  lastMessage: snapshot.data!.docs[index]["last message"],
                  time: getTime(snapshot.data!.docs[index]["time"]),
                  chatRoomID: snapshot.data!.docs[index].id,
                );
              },
            );
          },
        )
        // Expanded(
        //   child: Container(
        //     margin: const EdgeInsets.only(top: 10, right: 5),
        //     child: StreamBuilder(
        //       stream: chatRooms,
        //       builder: (context, snapshot) {
        //         return snapshot.hasData
        //             ? ListView.builder(
        //                 itemCount: snapshot.data!.docs.length,
        //                 shrinkWrap: true,
        //                 itemBuilder: (context, index) {
        //                   return ChatListItem(
        //                     auth: widget.auth,
        //                     chat: widget.chat,
        //                     storage: widget.storage,
        //                     database: widget.database,
        //                     users: snapshot.data!.docs[index]["users"],
        //                     lastMessage: snapshot.data!.docs[index]["last message"],
        //                     time: getTime(snapshot.data!.docs[index]["time"]),
        //                     chatRoomID: snapshot.data!.docs[index].id,
        //                   );
        //           },
        //         )
        //             : Container();
        //       },
        //     ),
        //     // child: ListView.builder(
        //     //   itemCount: widget.data.length,
        //     //   itemBuilder: ((context, index) {
        //     //     return ChatListItem(chat: widget.data[index]);
        //     //   }),
        //     // ),
        //   ),
        // ),
      // SingleChildScrollView(
      //   physics: const BouncingScrollPhysics(),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       ListView.builder(
      //         itemCount: chatUsers.length,
      //         shrinkWrap: true,
      //         padding: const EdgeInsets.only(top: 16),
      //         physics: const NeverScrollableScrollPhysics(),
      //         itemBuilder: (context, index){
      //           return ChatListItem(
      //             name: chatUsers[index].name,
      //             messageText: chatUsers[index].messageText,
      //             imageUrl: chatUsers[index].imageURL,
      //             time: chatUsers[index].time,
      //             isMessageRead: (index == 0 || index == 3)?true:false,
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: const Text(""),
      backgroundColor: Colors.blue[800],
      actions: <Widget>[
        IconButton(onPressed: () => logout(context), icon: const Icon(Icons.logout), tooltip: "Вийти",)
      ],
    );
  }

  void logout(BuildContext context) {
    // Firebase logout
    Navigator.pushNamed(
      context,
      '/',
    );
  }
}