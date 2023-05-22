import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
//agent_tour_information,
class DatabaseBackend extends ChangeNotifier{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseBackend();
// Future<QuerySnapshot<Map<String, dynamic>>>
  Stream<QuerySnapshot> getAllTours() {
    return db.collection('Tours').snapshots();
  }

  List<String> getAllTourCompanies() {
    List<String> tourCompanies = <String>[];
    CollectionReference tourCompaniesDocuments = db.collection("Tour companies");
    tourCompaniesDocuments.get().then((value) {
      for (int i = 0; i < value.size; i++) {
        tourCompanies.add(value.docs[i].get("name"));
      }
    });
    return tourCompanies;
  }

  List<String> getAllUsersIDs() {
    List<String> res = <String>[];
    CollectionReference tourCompaniesDocuments = db.collection("Users");
    tourCompaniesDocuments.get().then((value) {
      for (int i = 0; i < value.size; i++) {
        res.add(value.docs[i].id);
      }
    });
    return res;
  }

  Map<String, dynamic> getUserInfo(String userID) {
    late Map<String, dynamic> userData;
    DocumentReference tourDocument = db.collection("Users").doc(userID);
    tourDocument.get().then(
          (DocumentSnapshot doc) {
        userData = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return userData;
  }

  void getUserSpecificInfo(String userID) {

  }

  Map<String, dynamic> getInfoByReference(DocumentReference docRef) {
    late Map<String, dynamic> info;
    docRef.get().then((DocumentSnapshot dataValue) {
      info = dataValue.data() as Map<String, dynamic>;
    });
    return info;
  }

  Map<String, dynamic> getTourInfo(String tourID) {
    late Map<String, dynamic> tourData;
    DocumentReference tourDocument = db.collection("Tours").doc(tourID);
    tourDocument.get().then(
          (DocumentSnapshot doc) {
        tourData = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return tourData;
  }

  Map<String, dynamic> getReservingInfo(String reservingID) {
    late Map<String, dynamic> reservingData;
    DocumentReference reservingDocument = db.collection("Reservings").doc(reservingID);
    reservingDocument.get().then(
          (DocumentSnapshot doc) {
            reservingData = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return reservingData;
  }

  Map<String, dynamic> getChatRoomInfo(String chatRoomID) {
    late Map<String, dynamic> chatRoomData;
    DocumentReference chatRoomDocument = db.collection("Reservings").doc(chatRoomID);
    chatRoomDocument.get().then(
          (DocumentSnapshot doc) {
            chatRoomData = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return chatRoomData;
  }

  String addNewDocument(String collectionName, Map<String, dynamic> documentData, [String? id]) {
    late String newID;
    if (id != null) {
      db.collection(collectionName).doc(id).set(documentData);
      newID = id;
    }
    else {
      db.collection(collectionName).add(documentData).then((DocumentReference doc) {
        newID = doc.id;
      });
    }
    return newID;
  }

  void updateDocumentData(String collectionName, String documentID, Map<String, dynamic> updatedData) {
    final documentRef = db.collection(collectionName).doc(documentID);
    documentRef.update(updatedData);
  }

  void deleteDocument(String collectionName, String documentID) {
    db.collection(collectionName).doc(documentID).delete();
  }

  Future<void> createChatRoom(String chatRoomID, chatRoomMap) async {
    await db
        .collection("Chat rooms")
        .add(chatRoomMap);
  }

  Future<QuerySnapshot> getChatRoom(String chatRoomID) async {
    return await db
        .collection("Chat rooms")
        .where("room_ID", isEqualTo: chatRoomID)
        .get();
  }
}
