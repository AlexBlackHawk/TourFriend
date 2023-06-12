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
  List<GestureDetector> dataDR = <GestureDetector>[];
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
  //     Map<String, dynamic> reservingData = await widget.database.getInfoByReference(element);
  //     Map<String, dynamic> userData = await widget.database.getInfoByReference(reservingData["client"]);
  //     Map<String, dynamic> tourData = await widget.database.getInfoByReference(reservingData["tour"]);
  //     String city = tourData['city'];
  //     String country = tourData['country'];
  //     String name = tourData['name'];
  //     String photo = tourData['photo'][0];
  //     String id = element.id;
  //
  //     GestureDetector gd = GestureDetector(
  //       onTap: (){
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) {
  //               return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
  //             },
  //           ),
  //         );
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
  //         child: Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: Row(
  //                 children: <Widget>[
  //                   Image(image: NetworkImage(photo),),
  //                   const SizedBox(width: 16,),
  //                   Expanded(
  //                     child: Container(
  //                       color: Colors.transparent,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Text(name, style: const TextStyle(fontSize: 16),),
  //                           const SizedBox(height: 6,),
  //                           Text("$city, $country ",style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               color: Colors.white,
  //               child: Column(
  //                   children: <Widget> [
  //                     Expanded(
  //                       child: CircleAvatar(
  //                         backgroundImage: NetworkImage(userData["avatar"]),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         userData["name"],
  //                       ),
  //                     ),
  //                   ]
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //     dataDR.add(gd);
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
                itemCount: snapshotUser.data!["ordered tours"].length, // тут ідентифікатори резервувань, не турів
                itemBuilder: (BuildContext context, int index) {
                  DocumentReference userReserve = snapshotUser.data!["ordered tours"][index];
                  Future<Map<String, dynamic>> reserveInfo = widget.database.getInfoByReference(userReserve);
                  return FutureBuilder<Map<String, dynamic>>(
                    future: reserveInfo,
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotReserve) {
                      if (snapshotReserve.hasData) {
                        Future<Map<String, dynamic>> tourData = widget.database.getInfoByReference(snapshotReserve.data!["tour"]);
                        return FutureBuilder<Map<String, dynamic>>(
                          future: tourData,
                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotTour) {
                            if (snapshotTour.hasData) {
                              String city = snapshotTour.data!['city'];
                              String country = snapshotTour.data!['country'];
                              String name = snapshotTour.data!['name'];
                              String photo = snapshotTour.data!['photos'][0];
                              Future<Map<String, dynamic>> clientData = widget.database.getInfoByReference(snapshotReserve.data!["client"]);
                              return FutureBuilder<Map<String, dynamic>>(
                                future: clientData,
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> clientSnapshot) {
                                  if (clientSnapshot.hasData) {
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
                                      trailing: Column(
                                        children: [
                                          CircleAvatar(radius: 20, backgroundImage: NetworkImage(clientSnapshot.data!["avatar"])),
                                          Expanded(child: Text(clientSnapshot.data!["name"])),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: userReserve.id,);
                                            },
                                          ),
                                        );
                                      },
                                    );

                                    // return GestureDetector(
                                    //   onTap: (){
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) {
                                    //           return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: userReserve.id,);
                                    //         },
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                                    //     child: Row(
                                    //       children: <Widget>[
                                    //         Expanded(
                                    //           child: Row(
                                    //             children: <Widget>[
                                    //               Image(image: NetworkImage(photo),),
                                    //               const SizedBox(width: 16,),
                                    //               Expanded(
                                    //                 child: Container(
                                    //                   color: Colors.transparent,
                                    //                   child: Column(
                                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                                    //                     children: <Widget>[
                                    //                       Expanded(
                                    //                         child: Text(name, style: const TextStyle(fontSize: 16),),
                                    //                       ),
                                    //                       const SizedBox(height: 6,),
                                    //                       Expanded(
                                    //                         child: Text("$city, $country ",style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //           color: Colors.white,
                                    //           child: Column(
                                    //               children: <Widget> [
                                    //                 Expanded(
                                    //                   child: CircleAvatar(
                                    //                     backgroundImage: NetworkImage(clientSnapshot.data!["avatar"]),
                                    //                   ),
                                    //                 ),
                                    //                 Expanded(
                                    //                   child: Text(
                                    //                     clientSnapshot.data!["name"],
                                    //                   ),
                                    //                 ),
                                    //               ]
                                    //           ),
                                    //         )
                                    //         // FutureBuilder<Map<String, dynamic>>(
                                    //         //   future: clientData,
                                    //         //   builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotClient) {
                                    //         //     if (snapshotClient.hasData) {
                                    //         //       return Container(
                                    //         //         color: Colors.white,
                                    //         //         child: Column(
                                    //         //             children: <Widget> [
                                    //         //               Expanded(
                                    //         //                 child: CircleAvatar(
                                    //         //                   backgroundImage: NetworkImage(snapshotClient.data!["avatar"]),
                                    //         //                 ),
                                    //         //               ),
                                    //         //               Expanded(
                                    //         //                 child: Text(
                                    //         //                   snapshotClient.data!["name"],
                                    //         //                 ),
                                    //         //               ),
                                    //         //             ]
                                    //         //         ),
                                    //         //       );
                                    //         //     } else if (snapshotClient.hasError) {
                                    //         //       return const Text('Error');
                                    //         //       // return const Center(
                                    //         //       //   child: Text('Error'),
                                    //         //       // );
                                    //         //     } else {
                                    //         //       return const CircularProgressIndicator();
                                    //         //       // return Center(
                                    //         //       //   child: Column(
                                    //         //       //     children: const [
                                    //         //       //       SizedBox(
                                    //         //       //         width: 60,
                                    //         //       //         height: 60,
                                    //         //       //         child: CircularProgressIndicator(),
                                    //         //       //       ),
                                    //         //       //       Padding(
                                    //         //       //         padding: EdgeInsets.only(top: 16),
                                    //         //       //         child: Text('Awaiting result...'),
                                    //         //       //       ),
                                    //         //       //     ],
                                    //         //       //   ),
                                    //         //       // );
                                    //         //     }
                                    //         //   },
                                    //         // ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );
                                  } else if (clientSnapshot.hasError) {
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
                              // return Center(
                              //   child: Column(
                              //     children: const [
                              //       SizedBox(
                              //         width: 60,
                              //         height: 60,
                              //         child: CircularProgressIndicator(),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(top: 16),
                              //         child: Text('Awaiting result...'),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            }
                          },
                        );
                      } else if (snapshotUser.hasError) {
                        return const Text('');
                      } else {
                        return const Text('');
                      }
                    },
                  );
                },
              );
            } else if (snapshotUser.hasError) {
              return const Text('');
            } else {
              return const Text('');
            }
          },
        )
    );
  }
}



// return ListTile(
//   leading: Image(image: NetworkImage(photo),),
//   title: Text(name),
//   subtitle: Row(
//     children: <Widget>[
//       const Icon(
//         Icons.place,
//         color: Colors.black,
//       ),
//       Text(
//         " $city, $country ",
//         style: const TextStyle(
//           color: Colors.black,
//         ),
//       ),
//     ],
//   ),
//   trailing: IconButton(
//       onPressed: () {
//         isSaved = isSaved ? false : true;
//         DocumentReference ref = widget.database.db.doc("Tours/$id");
//         setState(() {
//           if (isSaved) {
//             widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
//               "ordered tours": FieldValue.arrayUnion([ref])
//             });
//           }
//           else {
//             widget.database.db.collection("Users").doc(widget.auth.user!.uid).update({
//               "ordered tours": FieldValue.arrayRemove([ref])
//             });
//           }
//         });
//       },
//       icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
//           color: isSaved ? Colors.red : null)),
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
//         },
//       ),
//     );
//   },
// );






