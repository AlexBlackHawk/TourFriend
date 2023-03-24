import 'package:flutter/material.dart';
import '/widgets/app_bar_sign_in_up.dart';
import '/widgets/sign_up_as_btn_set.dart';

class SignUpOptions extends StatefulWidget {
  const SignUpOptions({super.key});

  @override
  State<SignUpOptions> createState() => _SignUpOptionsState();
}

class _SignUpOptionsState extends State<SignUpOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarSignInUp(
        appBarText: "Зареєструватись",
      ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(32),
        child: const SignUpAsButtons(),
      ),
    );
  }
}