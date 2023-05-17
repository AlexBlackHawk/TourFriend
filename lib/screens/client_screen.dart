import 'package:flutter/material.dart';
import 'account_information_client.dart';
import 'chat_list.dart';
import 'client_tours.dart';
import 'tour_list.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ClientScreen extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const ClientScreen({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      TourList(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
      ClientTours(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
      ChatList(data: ,),
      AccountInformationClient(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, userID: widget.auth.user!.uid,),
    ];
    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Тури',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Мої тури',
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
        selectedItemColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}