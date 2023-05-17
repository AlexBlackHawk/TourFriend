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
  List<DocumentReference>? dataDR;
  //= List.from(widget.database.db.collection("Users").doc(widget.auth.user!.uid));

  @override
  void initState() {
    super.initState();
    setState(() {
      getdata();
    });
  }

  getdata() async{
    dataDR = <DocumentReference>[];
    await widget.database.db.collection("Users").doc(widget.auth.user!.uid).get().then((value){
      setState(() {
        // first add the data to the Offset object
        for (var element in List.from(value.data()!['added tours'])) {
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
          var lst = widget.database.getUserInfo(widget.auth.user!.uid)["added tours"];
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
                        "added tours": FieldValue.arrayUnion([ref])
                      });
                    }
                    else {
                      widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                        "added tours": FieldValue.arrayRemove([ref])
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
                    return AgentTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: id,);
                  },
                ),
              );
            },
          );
        },
      )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddingTour(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
              },
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}