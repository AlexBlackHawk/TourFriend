import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseBackend extends ChangeNotifier{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseBackend();

  Stream<QuerySnapshot> getAllTours() {
    return db.collection('Tours').snapshots();
  }

  Future<List<String>> getAllTourCompanies() async {
    QuerySnapshot tourCompaniesDocuments = await db.collection("Tour companies").get();
    List<String> documentIds = tourCompaniesDocuments.docs.map((doc) => doc["name"].toString()).toList();
    return documentIds;
  }

  Future<List<String>> getAllUsersIDs() async {
    QuerySnapshot usersDocuments = await db.collection("Users").get();
    List<String> documentIds = usersDocuments.docs.map((doc) => doc.id).toList();
    return documentIds;
  }

  Future<Map<String, dynamic>> getUserInfo(String userID) async {
    DocumentReference tourDocument = db.collection("Users").doc(userID);
    DocumentSnapshot snapshot = await tourDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> getInfoByReference(DocumentReference docRef) async {
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> getTourInfo(String tourID) async {
    DocumentReference tourDocument = db.collection("Tours").doc(tourID);
    DocumentSnapshot snapshot = await tourDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> getReservingInfo(String reservingID) async {
    DocumentReference reservingDocument = db.collection("Reservings").doc(reservingID);
    DocumentSnapshot snapshot = await reservingDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> getChatRoomInfo(String chatRoomID) async {
    DocumentReference chatRoomDocument = db.collection("Chats").doc(chatRoomID);
    DocumentSnapshot snapshot = await chatRoomDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<String> addNewDocument(String collectionName, Map<String, dynamic> documentData, [String? id]) async {
    late String newID;
    if (id != null) {
      db.collection(collectionName).doc(id).set(documentData);
      newID = id;
    }
    else {
      DocumentReference snapshot = await db.collection(collectionName).add(documentData);
      newID = snapshot.id;
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
}
