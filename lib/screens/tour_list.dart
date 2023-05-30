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
  late Stream<QuerySnapshot> allTours;
  // Map<String, dynamic>? myInfo;
  // List<ListTile> tiles = <ListTile>[];
  // bool? isSaved;
  @override
  void initState () {
    super.initState();
    allTours = widget.database.getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Всі тури"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
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
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              String city = data['city'];
              String country = data['country'];
              String name = data['name'];
              String photo = data['photos'][0];
              String id = document.id;
              Future<Map<String, dynamic>> myInfo = widget.database.getUserInfo(widget.auth.user!.uid);

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
                      "$city, $country",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                trailing: FutureBuilder<Map<String, dynamic>> (
                  future: myInfo,
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      bool isSaved = snapshot.data!["favorite tours"].contains(id);
                      return IconButton(
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
                              color: isSaved ? Colors.red : null));
                    } else if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
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
            }).toList().cast(),
          );
        },
      ),
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