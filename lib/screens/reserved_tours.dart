import 'package:flutter/material.dart';
import 'client_reserving_info.dart';

class ReservedTours extends StatefulWidget {
  const ReservedTours({super.key});

  @override
  State<ReservedTours> createState() => _ReservedToursState();
}

class _ReservedToursState extends State<ReservedTours> {

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
            trailing: IconButton(onPressed: () {}, icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.red : null)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ClientReservingInfo();
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