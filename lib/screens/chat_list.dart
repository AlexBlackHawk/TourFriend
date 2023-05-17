import 'package:flutter/material.dart';
import '../widgets/chat_list_item.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.data});
  final List<dynamic> data;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ghbjlmk"),
        automaticallyImplyLeading: false,
      ),
      //backgroundColor: Colors[],
      body: Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 10, right: 5),
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: ((context, index) {
              return ChatListItem(chat: widget.data[index]);
            }),
          ),
        ),
      )
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