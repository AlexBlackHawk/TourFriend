import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class Utils {
//   static StreamTransformer transformer<T>(
//       T Function(Map<String, dynamic> json) fromJson) =>
//       StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
//         handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
//           final snaps = data.docs.map((doc) => doc.data()).toList();
//           final users = snaps.map((json) => fromJson(json)).toList();
//
//           sink.add(users);
//         },
//       );
//
//   static dynamic toDateTime(Timestamp value) {
//     if (value == null) return null;
//
//     return value.toDate();
//   }
//
//   static dynamic fromDateTimeToJson(DateTime date) {
//     if (date == null) return null;
//
//     return date.toUtc();
//   }
// }
//
// class MessageField {
//   static final String createdAt = 'createdAt';
// }
//
// class Message {
//   final String idUser;
//   final String urlAvatar;
//   final String username;
//   final String message;
//   final DateTime createdAt;
//
//   const Message({
//     required this.idUser,
//     required this.urlAvatar,
//     required this.username,
//     required this.message,
//     required this.createdAt,
//   });
//
//   static Message fromJson(Map<String, dynamic> json) => Message(
//     idUser: json['idUser'],
//     urlAvatar: json['urlAvatar'],
//     username: json['username'],
//     message: json['message'],
//     createdAt: Utils.toDateTime(json['createdAt']),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'idUser': idUser,
//     'urlAvatar': urlAvatar,
//     'username': username,
//     'message': message,
//     'createdAt': Utils.fromDateTimeToJson(createdAt),
//   };
// }
//
// class UserField {
//   static final String lastMessageTime = 'lastMessageTime';
// }
//
// class User {
//   final String idUser;
//   final String name;
//   final String urlAvatar;
//   final DateTime lastMessageTime;
//
//   const User({
//     this.idUser,
//     required this.name,
//     required this.urlAvatar,
//     required this.lastMessageTime,
//   });
//
//   User copyWith({
//     String idUser,
//     String name,
//     String urlAvatar,
//     String lastMessageTime,
//   }) =>
//       User(
//         idUser: idUser ?? this.idUser,
//         name: name ?? this.name,
//         urlAvatar: urlAvatar ?? this.urlAvatar,
//         lastMessageTime: lastMessageTime ?? this.lastMessageTime,
//       );
//
//   static User fromJson(Map<String, dynamic> json) => User(
//     idUser: json['idUser'],
//     name: json['name'],
//     urlAvatar: json['urlAvatar'],
//     lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'idUser': idUser,
//     'name': name,
//     'urlAvatar': urlAvatar,
//     'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
//   };
// }

// final FirebaseFirestore db = FirebaseFirestore.instance;
// ChatBackend();
//
// static Stream<List<User>> getUsers() => FirebaseFirestore.instance
//     .collection('users')
// .orderBy(UserField.lastMessageTime, descending: true)
//     .snapshots()
//     .transform(Utils.transformer(User.fromJson));
//
// static Future uploadMessage(String idUser, String message) async {
// final refMessages =
// FirebaseFirestore.instance.collection('Chats/$idUser/messages');
//
// final newMessage = Message(
// idUser: myId,
// urlAvatar: myUrlAvatar,
// username: myUsername,
// message: message,
// createdAt: DateTime.now(),
// );
// await refMessages.add(newMessage.toJson());
//
// final refUsers = FirebaseFirestore.instance.collection('Users');
// await refUsers
//     .doc(idUser)
//     .update({UserField.lastMessageTime: DateTime.now()});
// }
//
// static Stream<List<Message>> getMessages(String idUser) =>
// FirebaseFirestore.instance
//     .collection('chats/$idUser/messages')
//     .orderBy(MessageField.createdAt, descending: true)
//     .snapshots()
//     .transform(Utils.transformer(Message.fromJson));
//
// static Future addRandomUsers(List<User> users) async {
// final refUsers = FirebaseFirestore.instance.collection('Users');
//
// final allUsers = await refUsers.get();
// if (allUsers.size != 0) {
// return;
// } else {
// for (final user in users) {
// final userDoc = refUsers.doc();
// final newUser = user.copyWith(idUser: userDoc.id);
//
// await userDoc.set(newUser.toJson());
// }
// }

class ChatBackend extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addChatRoom(chatRoom) async {
    late String id;
    DocumentReference snapshot = await db.collection("Chat rooms").add(chatRoom);
    id = snapshot.id;
    return id;
  }

  Stream<QuerySnapshot> getChats(String chatRoomId){
    return db.collection("Chat rooms").doc(chatRoomId).collection("Chats").orderBy('time').snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    db.collection("Chat rooms").doc(chatRoomId).collection("Chats").add(chatMessageData).catchError((e) {
      print(e.toString());
    });
  }

  Stream<QuerySnapshot> getUserChats(String itIsMyName) {
    return db.collection("Chat rooms").where('users', arrayContains: itIsMyName).snapshots();
  }

  Future<String?> getChatRoomID(String firstUser, String secondUser) async {
    String? id;
    QuerySnapshot chatDocument = await db.collection("Chat rooms").where("users", arrayContains: firstUser).where("users", arrayContains: secondUser).get();
      if(chatDocument.docs.isNotEmpty) {
        id = chatDocument.docs[0].id;
      }
    return id;
  }
}

//   Stream<QuerySnapshot> getAllMessages() {
//     return ;
//   }
//
//   void createMessageRoom(String firstUser, String secondUser) {
//     Map<String, dynamic> documentData = <String, dynamic>{
//       "first user": db.doc("Users/$firstUser"),
//       "second user": db.doc("Users/$secondUser"),
//       "messages": []
//     };
//     db.collection("Chats").add(documentData);
//   }
//
//   void insertMessage(String message, DateTime time, String sender, String id) {
//
//     Map<String, dynamic> documentData = <String, dynamic>{
//       "message": message,
//       "sender": db.doc("Users/$sender"),
//       "time": time
//     };
//     db.collection("Chats").doc(id).update({
//       "anArray": FieldValue.arrayUnion([documentData])
//     });
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'constants/all_constants.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
//
// class ChatMessages {
//   String idFrom;
//   String idTo;
//   String timestamp;
//   String content;
//   int type;
//
//   ChatMessages(
//       {required this.idFrom,
//         required this.idTo,
//         required this.timestamp,
//         required this.content,
//         required this.type});
//
//   Map<String, dynamic> toJson() {
//     return {
//       FirestoreConstants.idFrom: idFrom,
//       FirestoreConstants.idTo: idTo,
//       FirestoreConstants.timestamp: timestamp,
//       FirestoreConstants.content: content,
//       FirestoreConstants.type: type,
//     };
//   }
//
//   factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
//     String idFrom = documentSnapshot.get(FirestoreConstants.idFrom);
//     String idTo = documentSnapshot.get(FirestoreConstants.idTo);
//     String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
//     String content = documentSnapshot.get(FirestoreConstants.content);
//     int type = documentSnapshot.get(FirestoreConstants.type);
//
//     return ChatMessages(
//         idFrom: idFrom,
//         idTo: idTo,
//         timestamp: timestamp,
//         content: content,
//         type: type);
//   }
// }
//
// class ChatUser extends Equatable {
//   final String id;
//   final String photoUrl;
//   final String displayName;
//   final String phoneNumber;
//   final String aboutMe;
//
//   const ChatUser(
//       {required this.id,
//         required this.photoUrl,
//         required this.displayName,
//         required this.phoneNumber,
//         required this.aboutMe});
//
//   ChatUser copyWith({
//     String? id,
//     String? photoUrl,
//     String? nickname,
//     String? phoneNumber,
//     String? email,
//   }) =>
//       ChatUser(
//           id: id ?? this.id,
//           photoUrl: photoUrl ?? this.photoUrl,
//           displayName: nickname ?? displayName,
//           phoneNumber: phoneNumber ?? this.phoneNumber,
//           aboutMe: email ?? aboutMe);
//
//   Map<String, dynamic> toJson() => {
//     FirestoreConstants.displayName: displayName,
//     FirestoreConstants.photoUrl: photoUrl,
//     FirestoreConstants.phoneNumber: phoneNumber,
//     FirestoreConstants.aboutMe: aboutMe,
//   };
//   factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
//     String photoUrl = "";
//     String nickname = "";
//     String phoneNumber = "";
//     String aboutMe = "";
//
//     try {
//       photoUrl = snapshot.get(FirestoreConstants.photoUrl);
//       nickname = snapshot.get(FirestoreConstants.displayName);
//       phoneNumber = snapshot.get(FirestoreConstants.phoneNumber);
//       aboutMe = snapshot.get(FirestoreConstants.aboutMe);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//     return ChatUser(
//         id: snapshot.id,
//         photoUrl: photoUrl,
//         displayName: nickname,
//         phoneNumber: phoneNumber,
//         aboutMe: aboutMe);
//   }
//   @override
//   // TODO: implement props
//   List<Object?> get props => [id, photoUrl, displayName, phoneNumber, aboutMe];
// }
//
// class ChatProvider {
//   final SharedPreferences prefs;
//   final FirebaseFirestore firebaseFirestore;
//   final FirebaseStorage firebaseStorage;
//
//   ChatProvider(
//       {required this.prefs,
//         required this.firebaseStorage,
//         required this.firebaseFirestore});
//
//   UploadTask uploadImageFile(File image, String filename) {
//     Reference reference = firebaseStorage.ref().child(filename);
//     UploadTask uploadTask = reference.putFile(image);
//     return uploadTask;
//   }
//
//   Future<void> updateFirestoreData(
//       String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
//     return firebaseFirestore
//         .collection(collectionPath)
//         .doc(docPath)
//         .update(dataUpdate);
//   }
//
//   Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
//     return firebaseFirestore
//         .collection(FirestoreConstants.pathMessageCollection)
//         .doc(groupChatId)
//         .collection(groupChatId)
//         .orderBy(FirestoreConstants.timestamp, descending: true)
//         .limit(limit)
//         .snapshots();
//   }
//
//   void sendChatMessage(String content, int type, String groupChatId,
//       String currentUserId, String peerId) {
//     DocumentReference documentReference = firebaseFirestore
//         .collection(FirestoreConstants.pathMessageCollection)
//         .doc(groupChatId)
//         .collection(groupChatId)
//         .doc(DateTime.now().millisecondsSinceEpoch.toString());
//     ChatMessages chatMessages = ChatMessages(
//         idFrom: currentUserId,
//         idTo: peerId,
//         timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
//         content: content,
//         type: type);
//
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       transaction.set(documentReference, chatMessages.toJson());
//     });
//   }
// }
//
// class MessageType {
//   static const text = 0;
//   static const image = 1;
//   static const sticker = 2;
// }
//
//
// // class UserChat {
// //   String name;
// //   String messageText;
// //   String imageURL;
// //   String time;
// //   UserChat({required this.name, required this.messageText, required this.imageURL, required this.time});
// // }
// //
// // class MessageChat {
// //   final String roomID;
// //   final String fromUser;
// //   final String text;
// //   final String type;
// //   final String time;
// //   MessageChat({required this.roomID, required this.fromUser, required this.text, required this.type, required this.time});
// // }
// //
// // class ChatBackend extends ChangeNotifier {
// //   final FirebaseFirestore db = FirebaseFirestore.instance;
// //   ChatBackend();
// //
// //   Stream<QuerySnapshot> getMessageWithChatroomID(String roomID) {
// //     return db
// //         .collection("Messages")
// //         .where("room_ID", isEqualTo: roomID)
// //         .snapshots();
// //   }
// //
// //   Future<void> sendChatMessage(MessageChat chatMessage, String roomID) async {
// //     await db
// //         .collection("Messages")
// //         .doc(DateTime.now().millisecondsSinceEpoch.toString())
// //         .set({
// //       "room_ID": chatMessage.roomID,
// //       "from_user": chatMessage.fromUser,
// //       "text": chatMessage.text,
// //       "type": chatMessage.type,
// //       "time": chatMessage.time,
// //     });
// //   }
// // }
