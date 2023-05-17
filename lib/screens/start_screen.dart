import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/widgets/start_screen_btn_set.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final AuthenticationBackend auth = AuthenticationBackend();
  final ChatBackend chat = ChatBackend();
  final StorageBackend storage = StorageBackend();
  final DatabaseBackend database = DatabaseBackend();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/phone_image.png'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black12,
              Colors.black87,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: StartScreenButtons(auth: auth, chat: chat, storage: storage, database: database,),
        ),
      ),
    );
  }
}
