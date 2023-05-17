import 'package:flutter/material.dart';
import 'account_information_tour_agent.dart';
import 'tour_agent_tours.dart';
import 'chat_list.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class TourAgentScreen extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const TourAgentScreen({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<TourAgentScreen> createState() => _TourAgentScreenState();
}

class _TourAgentScreenState extends State<TourAgentScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      TourAgentTours(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
      ChatList(),
      AccountInformationTourAgent(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, userID: widget.auth.user!.uid,),
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Тури',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чати',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Акаунт',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
