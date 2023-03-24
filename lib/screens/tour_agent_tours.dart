import 'package:flutter/material.dart';
import 'tours_added_by_agent.dart';
import 'agent_tours_reserved_by_clients.dart';

class TourAgentTours extends StatefulWidget {
  const TourAgentTours({super.key});

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
            title: const Text("fghbjkml;"),
            automaticallyImplyLeading: false,
          ),
          body: const TabBarView(
            children: [
              ToursAddedAgent(),
              AgentToursReservedClients()
            ],
          ),
        ),
      ),
    );
  }
}