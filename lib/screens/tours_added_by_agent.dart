import 'package:flutter/material.dart';
import 'adding_tour.dart';
import 'agent_tour_information.dart';

class ToursAddedAgent extends StatefulWidget {
  const ToursAddedAgent({super.key});

  @override
  State<ToursAddedAgent> createState() => _ToursAddedAgentState();
}

class _ToursAddedAgentState extends State<ToursAddedAgent> {
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
                    return const AgentTourInformation();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddingTour();
              },
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}