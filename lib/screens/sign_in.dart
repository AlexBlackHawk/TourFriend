import 'package:flutter/material.dart';
import '/widgets/app_bar_sign_in_up.dart';
import '/widgets/or_divider.dart';
import '/widgets/does_not_have_account.dart';
import 'client_screen.dart';
import 'tour_agent_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class UserSignIn extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const UserSignIn({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final authenticate = AuthenticationBackend();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarSignInUp(
        appBarText: "Увійти",
      ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        // alignment: Alignment.center,
        // padding: const EdgeInsets.all(32),
        padding: const EdgeInsets.only(left: 16,right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Введіть email та пароль для входу в акаунт.\nАбо увійдіть за допомогою соціальних мереж.",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color:Colors.white
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Введіть email",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color:Colors.white
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                  controller: emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Введіть пароль",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color:Colors.white
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  obscureText: true,
                  obscuringCharacter: "*",
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  cursorColor: Colors.black,
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (emailController.text != "" && passwordController.text != "") {
                    final res = widget.auth.emailPasswordSignIn(emailController.text, passwordController.text);
                    res.then((value) {
                      if (value != null) {
                        if (widget.database.getUserInfo(widget.auth.getUserID()!)["role"] == "Клієнт") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
                        }
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TourAgentScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
                        }
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                child: const Text(
                  "Увійти",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            DoesNotHaveAccount(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
            const SizedBox(
              height: 12.0,
            ),
            const OrDivider(),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // authenticate.googleSignInUp();
                    final res = widget.auth.googleSignInUp();
                    res.then((value) {
                      if (value.credential != null) {
                        if (widget.database.getAllUsersIDs().contains(widget.auth.getUserID()!)) {
                          if (widget.database.getUserInfo(widget.auth.getUserID()!)["role"] == "Клієнт") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                          else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TourAgentScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                        }
                        else {
                          widget.auth.deleteUser();
                        }
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFFF1E6FF),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/icon-google.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // authenticate.facebookSignInUp();
                    final res = widget.auth.facebookSignInUp();
                    res.then((value) {
                      if (value.credential != null) {
                        if (widget.database.getAllUsersIDs().contains(widget.auth.getUserID()!)) {
                          if (widget.database.getUserInfo(widget.auth.getUserID()!)["role"] == "Клієнт") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                          else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TourAgentScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                        }
                        else {
                          widget.auth.deleteUser();
                        }
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFFF1E6FF),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/icon-facebook.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // authenticate.twitterSignInUp();
                    final res = widget.auth.twitterSignInUp();
                    res.then((value) {
                      if (value.credential != null) {
                        if (widget.database.getAllUsersIDs().contains(widget.auth.getUserID()!)) {
                          if (widget.database.getUserInfo(widget.auth.getUserID()!)["role"] == "Клієнт") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                          else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TourAgentScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                                },
                              ),
                            );
                          }
                        }
                        else {
                          widget.auth.deleteUser();
                        }
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFFF1E6FF),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/icon-twitter.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
