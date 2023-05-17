import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tour_agent_reserving_info.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class AgentToursReservedClients extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const AgentToursReservedClients({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<AgentToursReservedClients> createState() => _AgentToursReservedClientsState();
}

class _AgentToursReservedClientsState extends State<AgentToursReservedClients> {
  List<DocumentReference>? dataDR;
  //= List.from(widget.database.db.collection("Users").doc(widget.auth.user!.uid));

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async{
    dataDR = <DocumentReference>[];
    await widget.database.db.collection("Users").doc(widget.auth.user!.uid).get().then((value){
      setState(() {
        // first add the data to the Offset object
        for (var element in List.from(value.data()!['ordered tours'])) {
          dataDR?.add(element);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: getAppBar(context),
      backgroundColor: Colors.white,
      body: dataDR != null ? ListView.builder(
        itemCount: dataDR!.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = widget.database.getInfoByReference(dataDR![index]);
          String city = data['city'];
          String country = data['country'];
          String name = data['name'];
          String photo = data['photo'][0];
          String id = dataDR![index].id;
          var lst = widget.database.getUserInfo(widget.auth.user!.uid)["ordered tours"];
          bool isSaved = lst.contain(id);

          return ListTile(
            leading: Image(image: NetworkImage(photo),),
            title: Text(name),
            subtitle: Row(
              children: <Widget>[
                const Icon(
                  Icons.place,
                  color: Colors.black,
                ),
                Text(
                  " $city, $country ",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
                onPressed: () {
                  isSaved = isSaved ? false : true;
                  DocumentReference ref = widget.database.db.doc("Tours/$id");
                  setState(() {
                    if (isSaved) {
                      widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                        "ordered tours": FieldValue.arrayUnion([ref])
                      });
                    }
                    else {
                      widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                        "ordered tours": FieldValue.arrayRemove([ref])
                      });
                    }
                  });
                },
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.red : null)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
                  },
                ),
              );
            },
          );
        },
      )
          : Container(),
    );
  }
}