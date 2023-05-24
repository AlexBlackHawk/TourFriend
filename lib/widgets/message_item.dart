import 'package:flutter/material.dart';
import '../backend_authentication.dart';
import '../backend_database.dart';
import '../backend_storage.dart';
import '../backend_chat.dart';

class MessageItem extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String message;
  final bool senderMe;
  final String? photo;
  const MessageItem({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.message, required this.senderMe, required this.photo});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.senderMe) {
      return Container(
        margin: const EdgeInsets.only(right: 10, top: 20, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 35, 156, 255),
                size: 14,
              )
            ]),
      );
    }
    else {
      return Container(
        margin: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.photo!),
            radius: 17,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
        ]),
      );
    }
  }
}
