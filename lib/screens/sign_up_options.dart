import 'package:flutter/material.dart';
import '/widgets/app_bar_sign_in_up.dart';
import '/widgets/sign_up_as_btn_set.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class SignUpOptions extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const SignUpOptions({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<SignUpOptions> createState() => _SignUpOptionsState();
}

class _SignUpOptionsState extends State<SignUpOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarSignInUp(
        appBarText: "Зареєструватись",
      ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        alignment: Alignment.center,
        child: SignUpAsButtons(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
      ),
    );
  }
}