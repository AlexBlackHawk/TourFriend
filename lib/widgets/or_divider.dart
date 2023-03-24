import 'package:flutter/material.dart';

class OrDivider extends StatefulWidget {
  const OrDivider({super.key});

  @override
  State<OrDivider> createState() => _OrDividerState();
}

class _OrDividerState extends State<OrDivider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildDivider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "АБО",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        buildDivider(),
      ],
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Colors.white,
        height: 1.5,
      ),
    );
  }
}