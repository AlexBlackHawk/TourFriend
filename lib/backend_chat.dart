import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserChat {
  String name;
  String messageText;
  String imageURL;
  String time;
  UserChat({required this.name, required this.messageText, required this.imageURL, required this.time});
}

class MessageChat {
  final String roomID;
  final String fromUser;
  final String text;
  final String type;
  final String time;
  MessageChat({required this.roomID, required this.fromUser, required this.text, required this.type, required this.time});
}

class ChatBackend extends ChangeNotifier {
  final FirebaseFirestore db;

  ChatBackend({required this.db});

  Stream<QuerySnapshot> getMessageWithChatroomID(String roomID) {
    return db
        .collection("Messages")
        .where("room_ID", isEqualTo: roomID)
        .snapshots();
  }

  Future<void> sendChatMessage(MessageChat chatMessage, String roomID) async {
    await db
        .collection("Messages")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "room_ID": chatMessage.roomID,
      "from_user": chatMessage.fromUser,
      "text": chatMessage.text,
      "type": chatMessage.type,
      "time": chatMessage.time,
    });
  }
}
