import 'package:flutter/material.dart';
import 'reserved_tours.dart';
import 'wish_list.dart';

class ClientTours extends StatefulWidget {
  const ClientTours({super.key});

  @override
  State<ClientTours> createState() => _ClientToursState();
}

class _ClientToursState extends State<ClientTours> with SingleTickerProviderStateMixin {

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
                Tab(text: "Заброньовані тури"),
                Tab(text: "Список бажань")
              ],
            ),
            title: const Text("Мої тури"),
            automaticallyImplyLeading: false,
          ),
          body: const TabBarView(
            children: [
              ReservedTours(),
              WishList()
            ],
          ),
        ),
      ),
    );
  }
}