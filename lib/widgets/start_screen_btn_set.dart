import 'package:flutter/material.dart';
import '/screens/sign_up_options.dart';
import '/screens/sign_in.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class StartScreenButtons extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;

  const StartScreenButtons({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<StartScreenButtons> createState() => _StartScreenButtonsState();
}

class _StartScreenButtonsState extends State<StartScreenButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Вітаємо в TourFriend\nУвійдіть в ваш акаунт або створіть новий",
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          // const Spacer(),
          const SizedBox(height: 20),
          SizedBox(
            height: 61,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserSignIn(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              child: const Text(
                "УВІЙТИ",
              ),
            ),
          ),
          const SizedBox(height: 10),
          // const Spacer(),
          SizedBox(
            height: 61,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpOptions(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              child: const Text(
                "ЗАРЕЄСТРУВАТИСЬ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}