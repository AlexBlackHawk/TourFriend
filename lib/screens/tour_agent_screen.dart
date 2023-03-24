import 'package:flutter/material.dart';
import 'account_information_tour_agent.dart';
import 'tour_agent_tours.dart';
import 'chat_list.dart';

class TourAgentScreen extends StatefulWidget {
  const TourAgentScreen({super.key});

  @override
  State<TourAgentScreen> createState() => _TourAgentScreenState();
}

class _TourAgentScreenState extends State<TourAgentScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TourAgentTours(),
    ChatList(),
    AccountInformationTourAgent(),
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
