import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/screens/start_screen.dart';
import 'reserved_tours.dart';
import 'wish_list.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ClientTours extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const ClientTours({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<ClientTours> createState() => _ClientToursState();
}

class _ClientToursState extends State<ClientTours> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const BackButton(),
      //   title: const Text("Мої тури"),
      //   automaticallyImplyLeading: false,
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) {
      //               return const StartScreen();
      //             },
      //           ),
      //         );
      //         widget.auth.userSignOut();
      //       },
      //       icon: const Icon(Icons.logout),
      //       tooltip: "Вийти",
      //     )
      //   ],
      // ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // leading: const BackButton(),
            title: const Text("Мої тури"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const StartScreen();
                      },
                    ),
                  );
                  widget.auth.userSignOut();
                },
                icon: const Icon(Icons.logout),
                tooltip: "Вийти",
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: "Заброньовані тури"),
                Tab(text: "Список бажань")
              ],
            ),
            // title: const Text("Мої тури"),
            // automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            children: [
              ReservedTours(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
              WishList(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,)
            ],
          ),
        ),
      ),
    );
  }
}