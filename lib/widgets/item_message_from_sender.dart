import 'package:flutter/material.dart';

class ItemMessageFromSender extends StatefulWidget {
  final String message;

  const ItemMessageFromSender({super.key, required this.message});

  @override
  State<ItemMessageFromSender> createState() => _ItemMessageFromSenderState();
}

class _ItemMessageFromSenderState extends State<ItemMessageFromSender> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 20, bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.check_circle,
              color: Color.fromARGB(255, 35, 156, 255),
              size: 14,
            )
          ]),
    );
  }
}