import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'client_tour_information.dart';

class WishList extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const WishList({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
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
  //   for (var element in docs['favorite tours']) {
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
  //               return ClientTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: id,);
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
                itemCount: snapshotUser.data!["favorite tours"].length,
                itemBuilder: (BuildContext context, int index) {
                  Future<Map<String, dynamic>> tourInfo = widget.database.getInfoByReference(snapshotUser.data!["favorite tours"][index]);
                  return FutureBuilder<Map<String, dynamic>>(
                    future: tourInfo,
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotTour) {
                      if (snapshotTour.hasData) {
                        String city = snapshotTour.data!['city'];
                        String country = snapshotTour.data!['country'];
                        String name = snapshotTour.data!['name'];
                        String photo = snapshotTour.data!['photo'][0];
                        bool isSaved = snapshotUser.data!["favorite tours"].contain(snapshotUser.data!["favorite tours"][index]);

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
                                      "favorite tours": FieldValue.arrayUnion([snapshotUser.data!["favorite tours"][index]])
                                    });
                                  }
                                  else {
                                    widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
                                      "favorite tours": FieldValue.arrayRemove([snapshotUser.data!["favorite tours"][index]])
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
                                  return ClientTourInformation(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tour: snapshotUser.data!["favorite tours"][index],);
                                },
                              ),
                            );
                          },
                        );
                      } else if (snapshotUser.hasError) {
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
        )
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