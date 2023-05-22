import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'firebase_options.dart';

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
