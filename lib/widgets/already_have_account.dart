import 'package:flutter/material.dart';
import '/screens/sign_in.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class AlreadyHaveAccount extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const AlreadyHaveAccount({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<AlreadyHaveAccount> createState() => _AlreadyHaveAccountState();
}

class _AlreadyHaveAccountState extends State<AlreadyHaveAccount> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Маєте акаунт? | ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return UserSignIn(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                },
              ),
            );
          },
          child: const Text(
            "Увійти",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}