import 'package:flutter/material.dart';

class AppBarSignInUp extends StatefulWidget implements PreferredSizeWidget {
  final String appBarText;
  const AppBarSignInUp({super.key, required this.appBarText});


  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height); //const Size.fromHeight(100)

  @override
  State<AppBarSignInUp> createState() => _AppBarSignInUpState();
}

class _AppBarSignInUpState extends State<AppBarSignInUp> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.appBarText),
      centerTitle: true,
      leading: const BackButton(),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}