import 'package:flutter/material.dart';
import 'tour_agent_reserving_info.dart';

class AgentToursReservedClients extends StatefulWidget {
  const AgentToursReservedClients({super.key});

  @override
  State<AgentToursReservedClients> createState() => _AgentToursReservedClientsState();
}

class _AgentToursReservedClientsState extends State<AgentToursReservedClients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: getAppBar(context),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 40,
        itemBuilder: (context, index) {
          String tourName = "";
          bool isSaved = true;

          return ListTile(
            leading: const Image(image: NetworkImage("https://cms.nhl.bamgrid.com/images/photos/341744276/960x540/cut.jpg"),),
            title: const Text("Fantasy spin: 2023 NHL Trade Deadline"),
            subtitle: Row(
              children: const <Widget>[
                Icon(
                  Icons.place,
                  color: Colors.black,
                ),
                Text(
                  " Барселона, Іспанія ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget> [
                  Expanded(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/no-profile-picture-icon.png"),
                      radius: 25,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Patrick Timothy Kane",
                    ),
                  ),
                ]
            ),
            // Expanded(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Radio(value: null, groupValue: null, onChanged: (Null? value) {  },
            //             // activeColor: Colors.white,
            //             // value: HotelService.breakfast,
            //             // groupValue: _serviceOption,
            //             // onChanged: (HotelService? value) {
            //             //   setState(() {
            //             //     _serviceOption = value;
            //             //   });
            //             // },
            //           ),
            //           // const Text("Сніданок"),
            //         ],
            //       ),
            //     ),
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const <Widget>[
            //       CircleAvatar(
            //         backgroundImage: NetworkImage("https://cms.nhl.bamgrid.com/images/headshots/current/168x168/8476999.png"),
            //         maxRadius: 25,
            //       ),
            //       Text(
            //         "Patrick Timothy Kane",
            //         style: TextStyle(
            //             fontSize: 15,
            //             fontWeight: FontWeight.w400,
            //             color:Colors.black
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const TourAgentReservingInfo();
                  },
                ),
              );
              // setState(() {
              //   if (isSaved) {
              //     // call a function to remove tour from wish list;
              //
              //   } else {
              //     // call a function to add tour to wish list;
              //
              //   }
              // });
            },
          );
        },
      ),
    );
  }
}