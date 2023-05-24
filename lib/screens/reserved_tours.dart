import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'client_reserving_info.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ReservedTours extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const ReservedTours({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<ReservedTours> createState() => _ReservedToursState();
}

class _ReservedToursState extends State<ReservedTours> {
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
    for (var element in docs['ordered tours']) {
      String id = element;
      DocumentReference docRef = widget.database.db.doc("Tours/$id");
      Map<String, dynamic> data = await widget.database.getInfoByReference(docRef);
      String city = data['city'];
      String country = data['country'];
      String name = data['name'];
      String photo = data['photo'][0];
      Map<String, dynamic> lst = await widget.database.getUserInfo(widget.auth.user!.uid);
      bool isSaved = lst["favorite tours"].contain(id);

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
        trailing: IconButton(
            onPressed: () {
              isSaved = isSaved ? false : true;
              setState(() {
                if (isSaved) {
                  widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                    "favorite tours": FieldValue.arrayUnion([id])
                  });
                }
                else {
                  widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                    "favorite tours": FieldValue.arrayRemove([id])
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
                return ClientReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
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