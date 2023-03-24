import 'package:flutter/material.dart';
import '/screens/sign_in.dart';

class AlreadyHaveAccount extends StatefulWidget {
  const AlreadyHaveAccount({super.key});

  @override
  State<AlreadyHaveAccount> createState() => _AlreadyHaveAccountState();
}

class _AlreadyHaveAccountState extends State<AlreadyHaveAccount> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Маєте акаунт? | ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const UserSignIn();
                },
              ),
            );
          },
          child: const Text(
            "Увійти",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}