import 'package:flutter/material.dart';
import '../backend_authentication.dart';
import '../backend_database.dart';
import '../backend_storage.dart';
import '../backend_chat.dart';
import '/screens/chat.dart';

class ChatListItem extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final List<String> users;
  final String lastMessage;
  final String time;
  final String chatRoomID;
  const ChatListItem({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.users, required this.lastMessage, required this.time, required this.chatRoomID});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.users.length; i++){
      if (widget.users[i] != widget.auth.user!.uid) {
        setState(() async {
          userData = await widget.database.getUserInfo(widget.users[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData != null) {
      return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Chat(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, chatRoomId: widget.chatRoomID,);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData!["photo"]),
                      maxRadius: 30,
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(userData!["name"], style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text(widget.lastMessage,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(widget.time,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
            ],
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }
}
