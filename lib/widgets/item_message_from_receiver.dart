import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';

class ItemMessageFromReceiver extends StatefulWidget {
  final String message;
  final String photo;
  final ChatBackend chatProvider;

  const ItemMessageFromReceiver({super.key, required this.message, required this.photo, required this.chatProvider});

  @override
  State<ItemMessageFromReceiver> createState() => _ItemMessageFromReceiverState();
}

class _ItemMessageFromReceiverState extends State<ItemMessageFromReceiver> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.photo),
          radius: 17,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ]),
    );
  }
}