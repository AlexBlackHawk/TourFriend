import 'package:flutter/material.dart';
import 'account_information_client.dart';
import 'chat_list.dart';
import 'client_tours.dart';
import 'tour_list.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';

class ClientScreen extends StatefulWidget {
  final ProgramUser user;
  const ClientScreen({super.key, required this.user});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TourList(),
    ClientTours(),
    ChatList(widget.user),
    AccountInformationClient(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
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