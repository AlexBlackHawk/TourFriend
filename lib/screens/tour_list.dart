import 'package:flutter/material.dart';
import 'client_tour_information.dart';

class TourList extends StatefulWidget {
  const TourList({super.key});

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ghbjlmk"),
        automaticallyImplyLeading: false,
      ),
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
                    return const ClientTourInformation();
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

  void logout(BuildContext context) {
    // Firebase logout
    Navigator.pushNamed(
      context,
      '/',
    );
  }
}