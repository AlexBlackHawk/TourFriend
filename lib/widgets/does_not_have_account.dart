import 'package:flutter/material.dart';
import '/screens/sign_up_options.dart';

class DoesNotHaveAccount extends StatefulWidget {
  const DoesNotHaveAccount({super.key});

  @override
  State<DoesNotHaveAccount> createState() => _DoesNotHaveAccountState();
}

class _DoesNotHaveAccountState extends State<DoesNotHaveAccount> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Не має акаунта? | ",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpOptions();
                },
              ),
            );
          },
          child: const Text(
            "Зареєструватись",
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