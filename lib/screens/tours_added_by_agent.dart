import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adding_tour.dart';
import 'agent_tour_information.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ToursAddedAgent extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const ToursAddedAgent({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<ToursAddedAgent> createState() => _ToursAddedAgentState();
}

class _ToursAddedAgentState extends State<ToursAddedAgent> {
  List<ListTile> dataDR = <ListTile>[];
  //= List.from(widget.database.db.collection("Users").doc(widget.auth.user!.uid));

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  getData() async{
    DocumentSnapshot docs = await widget.database.db.collection("Users").doc(widget.auth.user!.uid).get();
    for (var element in docs['added tours']) {
      Map<String, dynamic> data = await widget.database.getInfoByReference(element);
      String city = data['city'];
      String country = data['country'];
      String name = data['name'];
      String photo = data['photo'][0];
      String id = element.id;

      ListTile tile = ListTile(
        leading: Image(image: NetworkImage(photo),),
        title: Text(name),
        subtitle: Row(
          children: <Widget>[
            const Icon(
              Icons.place,
              color: Colors.black,
            ),
            Text(
              "$city, $country",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AgentTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: id,);
              },
            ),
          );
        },
      );
      dataDR.add(tile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: getAppBar(context),
      backgroundColor: Colors.white,
      body: dataDR.isNotEmpty ? ListView(
        children: dataDR,
      )
          : Container(),
    );
  }
}