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
      Map<String, dynamic> reservingData = await widget.database.getInfoByReference(element);
      Map<String, dynamic> userData = await widget.database.getInfoByReference(reservingData["client"]);
      Map<String, dynamic> tourData = await widget.database.getInfoByReference(reservingData["tour"]);
      String city = tourData['city'];
      String country = tourData['country'];
      String name = tourData['name'];
      String photo = tourData['photo'][0];
      String id = element.id;

      GestureDetector gd = GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TourAgentReservingInfo(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, reservingID: id,);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Image(image: NetworkImage(photo),),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(name, style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text("$city, $country ",style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                    children: <Widget> [
                      Expanded(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData["avatar"]),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          userData["name"],
                        ),
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      );
      dataDR.add(gd);
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








