import 'package:flutter/material.dart';
import 'tours_added_by_agent.dart';
import 'agent_tours_reserved_by_clients.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class TourAgentTours extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const TourAgentTours({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<TourAgentTours> createState() => _TourAgentToursState();
}

class _TourAgentToursState extends State<TourAgentTours> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors[],
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Мої тури"),
                Tab(text: "Заброньовані клієнтами тури")
              ],
            ),
            title: const Text("Тури"),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            children: [
              ToursAddedAgent(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
              AgentToursReservedClients(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,)
            ],
          ),
        ),
      ),
    );
  }
}