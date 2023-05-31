import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageBackend{
  final storageIns = FirebaseStorage.instance;

  Future<String> uploadFile(String pathInStorage, String pathToFile, String fileName) async {
    File file = File(pathToFile);
    var snapshot = await storageIns.ref().child(pathInStorage).child(fileName).putFile(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFile(String fileReference) async {
    await storageIns.refFromURL(fileReference).delete();
  }
}