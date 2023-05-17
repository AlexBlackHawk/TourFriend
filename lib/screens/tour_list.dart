import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'client_tour_information.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class TourList extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const TourList({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  Stream<QuerySnapshot>? allTours;
  @override
  void initState () {
    super.initState();
    setState(() {
      allTours = widget.database.getAllTours();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ghbjlmk"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: allTours != null ? StreamBuilder<QuerySnapshot>(
        stream: allTours,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              String city = data['city'];
              String country = data['country'];
              String name = data['name'];
              String photo = data['photo'][0];
              String id = document.id;
              var lst = widget.database.getUserInfo(widget.auth.user!.uid)["favorite tours"];
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
                            "favorite tours": FieldValue.arrayUnion([ref])
                          });
                        }
                        else {
                          widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                            "favorite tours": FieldValue.arrayRemove([ref])
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
                        return ClientTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: id);
                      },
                    ),
                  );
                },
              );
            })
                .toList()
                .cast(),
          );
        },
      )
        : Container(),
    );
  }

  void logout(BuildContext context) {
    // Firebase logout
    Navigator.pushNamed(
      context,
      '/',
    );
  }
}