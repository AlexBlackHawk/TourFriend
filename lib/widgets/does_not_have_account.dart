import 'package:flutter/material.dart';
import '/screens/sign_up_options.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class DoesNotHaveAccount extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const DoesNotHaveAccount({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<DoesNotHaveAccount> createState() => _DoesNotHaveAccountState();
}

class _DoesNotHaveAccountState extends State<DoesNotHaveAccount> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Не має акаунта? | ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpOptions(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                },
              ),
            );
          },
          child: const Text(
            "Зареєструватись",
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