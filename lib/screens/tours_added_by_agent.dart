import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/screens/adding_tour.dart';
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
  late Future<Map<String, dynamic>> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = widget.database.getUserInfo(widget.auth.user!.uid);
    // setState(() {
    //   getData();
    // });
  }

  // getData() async{
  //   DocumentSnapshot docs = await widget.database.db.collection("Users").doc(widget.auth.user!.uid).get();
  //   for (var element in docs['added tours']) {
  //     Map<String, dynamic> data = await widget.database.getInfoByReference(element);
  //     String city = data['city'];
  //     String country = data['country'];
  //     String name = data['name'];
  //     String photo = data['photo'][0];
  //     String id = element.id;
  //
  //     ListTile tile = ListTile(
  //       leading: Image(image: NetworkImage(photo),),
  //       title: Text(name),
  //       subtitle: Row(
  //         children: <Widget>[
  //           const Icon(
  //             Icons.place,
  //             color: Colors.black,
  //           ),
  //           Text(
  //             "$city, $country",
  //             style: const TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) {
  //               return AgentTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: id,);
  //             },
  //           ),
  //         );
  //       },
  //     );
  //     dataDR.add(tile);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: FutureBuilder<Map<String, dynamic>>(
          future: userInfo,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotUser) {
            if (snapshotUser.hasData) {
              return ListView.builder(
                itemCount: snapshotUser.data!["added tours"].length,
                itemBuilder: (BuildContext context, int index) {
                  String idTour = snapshotUser.data!["added tours"][index];
                  DocumentReference docRefTour = widget.database.db.doc("Tours/$idTour");
                  Future<Map<String, dynamic>> tourInfo = widget.database.getInfoByReference(docRefTour);
                  return FutureBuilder(
                    future: tourInfo,
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotTour) {
                      if (snapshotTour.hasData) {
                        String city = snapshotTour.data!['city'];
                        String country = snapshotTour.data!['country'];
                        String name = snapshotTour.data!['name'];
                        String photo = snapshotTour.data!['photos'][0];

                        return ListTile(
                          leading: Image(image: NetworkImage(photo),),
                          title: Expanded(
                            child: Text(name),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.place,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Text(
                                  "$city, $country",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AgentTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: idTour,);
                                },
                              ),
                            );
                          },
                        );
                      } else if (snapshotTour.hasError) {
                        return const Text('Error');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            } else if (snapshotUser.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return Center(
                child: Column(
                  children: const [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddingTour(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database);
              }
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}