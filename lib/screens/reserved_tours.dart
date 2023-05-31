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
  late Future<Map<String, dynamic>> userInfo;
  //= List.from(widget.database.db.collection("Users").doc(widget.auth.user!.uid));

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
  //   for (var element in docs['ordered tours']) {
  //     String id = element;
  //     DocumentReference docRef = widget.database.db.doc("Tours/$id");
  //     Map<String, dynamic> data = await widget.database.getInfoByReference(docRef);
  //     String city = data['city'];
  //     String country = data['country'];
  //     String name = data['name'];
  //     String photo = data['photo'][0];
  //     Map<String, dynamic> lst = await widget.database.getUserInfo(widget.auth.user!.uid);
  //     bool isSaved = lst["favorite tours"].contain(id);
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
  //       trailing: IconButton(
  //           onPressed: () {
  //             isSaved = isSaved ? false : true;
  //             setState(() {
  //               if (isSaved) {
  //                 widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
  //                   "favorite tours": FieldValue.arrayUnion([id])
  //                 });
  //               }
  //               else {
  //                 widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
  //                   "favorite tours": FieldValue.arrayRemove([id])
  //                 });
  //               }
  //             });
  //           },
  //           icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
  //               color: isSaved ? Colors.red : null)),
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) {
  //               return ClientReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
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
      // appBar: getAppBar(context),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: userInfo,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotUser) {
          if (snapshotUser.hasData) {
            return ListView.builder(
              itemCount: snapshotUser.data!["ordered tours"].length,
              itemBuilder: (BuildContext context, int index) {
                Future<Map<String, dynamic>> tourInfo = widget.database.getInfoByReference(snapshotUser.data!["favorite tours"][index]);
                return FutureBuilder(
                  future: tourInfo,
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotTour) {
                    if (snapshotTour.hasData) {
                      String idReserve = snapshotUser.data!["ordered tours"][index];
                      DocumentReference docRefTour = widget.database.db.doc("Tours/$idReserve");
                      Future<Map<String, dynamic>> tourInfo = widget.database.getInfoByReference(docRefTour);

                      return FutureBuilder<Map<String, dynamic>>(
                        future: tourInfo,
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotTour) {
                          if (snapshotTour.hasData) {
                            String city = snapshotTour.data!['city'];
                            String country = snapshotTour.data!['country'];
                            String name = snapshotTour.data!['name'];
                            String photo = snapshotTour.data!['photo'][0];
                            bool isSaved = snapshotUser.data!["ordered tours"].contain(idReserve);

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
                              trailing: IconButton(
                                  onPressed: () {
                                    isSaved = isSaved ? false : true;
                                    setState(() {
                                      if (isSaved) {
                                        widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                                          "favorite tours": FieldValue.arrayUnion([idReserve])
                                        });
                                      }
                                      else {
                                        widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                                          "favorite tours": FieldValue.arrayRemove([idReserve])
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
                                      return ClientReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: idReserve,);
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
    );
  }
}