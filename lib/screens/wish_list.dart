import 'package:flutter/material.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {

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
              setState(() {
                if (isSaved) {
                  // call a function to remove tour from wish list;

                } else {
                  // call a function to add tour to wish list;

                }
              });
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