import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/widgets/app_bar_sign_in_up.dart';
import '/widgets/or_divider.dart';
import '/widgets/already_have_account.dart';
import 'client_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

enum Sex { male, female }

class SignUpClient extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const SignUpClient({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<SignUpClient> createState() => _SignUpClientState();
}

class _SignUpClientState extends State<SignUpClient> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  DateTime? pickedDate;
  String? userSex;
  Sex? _option; // Write logic
  var sexString = {
    Sex.male : "Чоловіча",
    Sex.female : "Жіноча"
  };
  bool alreadyProvided = true;
  File? imageFile;
  String imagePath = "https://firebasestorage.googleapis.com/v0/b/tourfriend-93f6e.appspot.com/o/avatars%2Fno-profile-picture-icon.png?alt=media&token=248d06cd-1924-4ea2-9d61-11a925c99e7f";

  _getFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    birthdayController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarSignInUp(
        appBarText: "Зареєструватися",
      ),
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _getFromGallery();
                },
                child: imageFile != null ?
                  CircleAvatar(
                    backgroundImage: FileImage(imageFile!),
                    radius: 100,
                  ) :
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/no-profile-picture-icon.png"),
                    radius: 100,
                  ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ім'я",
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
                    keyboardType: TextInputType.name,
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
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Дата народження",
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
                    // cursorColor: Colors.black,
                    controller: birthdayController,
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = intl.DateFormat('dd-MM-yyyy').format(pickedDate!);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          birthdayController.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }

                      // if(pickedDate != null ){
                      //   print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      //   String formattedDate = intl.DateFormat('dd-MM-yyyy').format(pickedDate);
                      //   print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //   //you can implement different kind of Date Format here according to your requirement
                      //
                      //   setState(() {
                      //     birthdayController.text = formattedDate; //set output date to TextField value.
                      //   });
                      // }else{
                      //   print("Date is not selected");
                      // }
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Номер телефону",
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
                    keyboardType: TextInputType.phone,
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
                    controller: phoneController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
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
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Стать",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color:Colors.white
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Radio(
                            // activeColor: Colors.white,
                            value: Sex.male,
                            groupValue: _option,
                            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            onChanged: (Sex? value) {
                              setState(() {
                                _option = value;
                              });
                            },
                          ),
                          const Text(
                            'Чоловіча',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color:Colors.white
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            // activeColor: Colors.white,
                            value: Sex.female,
                            groupValue: _option,
                            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            onChanged: (Sex? value) {
                              setState(() {
                                _option = value;
                              });
                            },
                          ),
                          const Text(
                            'Жіноча',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color:Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Пароль",
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
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Підтвердьте пароль",
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
                    controller: confirmPasswordController,
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text != "" && emailController.text != "" && passwordController.text != "" && confirmPasswordController.text != "") {
                        if (passwordController.text == confirmPasswordController.text) {
                          final usu = widget.auth.userSignUp(emailController.text, passwordController.text);
                          String? id;
                          usu.then((value) {
                            setState(() {
                              id = value.user?.uid;
                            });
                          });
                          if (nameController.text != "") {
                            widget.auth.updateUserName(nameController.text);
                          }
                          String fileName = "";
                          String filePath = "";
                          if (imageFile != null) {
                            String fileExtension = p.extension(imageFile!.path);
                            if (id != null) {
                              fileName = "$id$fileExtension";
                              filePath = "avatars/$id$fileExtension";
                            }
                            widget.storage.uploadFile(filePath, imageFile!.path, fileName).then((value) {
                              setState(() {
                                imagePath = value;
                                widget.auth.updatePhoto(imagePath);
                              });
                            });
                          }
                          Map<String, dynamic> userData = <String, dynamic>{
                            "avatar": imagePath,
                            "birthday": pickedDate != null ? Timestamp.fromDate(pickedDate!) : null,
                            "favorite tours": FieldValue.arrayUnion([]),
                            "name": nameController.text,
                            "role": "Клієнт",
                            "sex": userSex,
                            "email": emailController.text,
                            "phone": phoneController.text,
                            "ordered tours": FieldValue.arrayUnion([]),
                          };
                          id != null ? widget.database.addNewDocument("Users", userData, id) : widget.database.addNewDocument("Users", userData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
                        }
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
                      'ЗАРЕЄСТРУВАТИСЬ',
                      style: TextStyle(color: Colors.white),
                    )
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              AlreadyHaveAccount(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,),
              const SizedBox(
                height: 12.0,
              ),
              const OrDivider(),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                // textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      final res = widget.auth.googleSignInUp();
                      res.then((value) {
                        if (value != null) {
                          String? avatar = widget.auth.getUserPhotoLink();
                          Map<String, dynamic> userData = <String, dynamic>{
                            "avatar": avatar ?? "https://firebasestorage.googleapis.com/v0/b/tourfriend-93f6e.appspot.com/o/avatars%2Fno-profile-picture-icon.png?alt=media&token=248d06cd-1924-4ea2-9d61-11a925c99e7f",
                            "birthday": null,
                            "favorite tours": FieldValue.arrayUnion([]),
                            "name": widget.auth.getUserName(),
                            "role": "Клієнт",
                            "sex": null,
                            "email": widget.auth.getUserEmail(),
                            "ordered tours": FieldValue.arrayUnion([]),
                          };
                          widget.database.addNewDocument("Users", userData, widget.auth.getUserID()!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
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
                      final res = widget.auth.facebookSignInUp();
                      res.then((value) {
                        if (value != null) {
                          String? avatar = widget.auth.getUserPhotoLink();
                          Map<String, dynamic> userData = <String, dynamic>{
                            "avatar": avatar ?? "https://firebasestorage.googleapis.com/v0/b/tourfriend-93f6e.appspot.com/o/avatars%2Fno-profile-picture-icon.png?alt=media&token=248d06cd-1924-4ea2-9d61-11a925c99e7f",
                            "birthday": null,
                            "favorite tours": FieldValue.arrayUnion([]),
                            "name": widget.auth.getUserName(),
                            "role": "Клієнт",
                            "sex": null,
                            "email": widget.auth.getUserEmail(),
                            "ordered tours": FieldValue.arrayUnion([]),
                          };
                          widget.database.addNewDocument("Users", userData, widget.auth.getUserID()!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
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
                      final res = widget.auth.facebookSignInUp();
                      res.then((value) {
                        if (value != null) {
                          String? avatar = widget.auth.getUserPhotoLink();
                          Map<String, dynamic> userData = <String, dynamic>{
                            "avatar": avatar ?? "https://firebasestorage.googleapis.com/v0/b/tourfriend-93f6e.appspot.com/o/avatars%2Fno-profile-picture-icon.png?alt=media&token=248d06cd-1924-4ea2-9d61-11a925c99e7f",
                            "birthday": null,
                            "favorite tours": FieldValue.arrayUnion([]),
                            "name": widget.auth.getUserName(),
                            "role": "Клієнт",
                            "sex": null,
                            "email": widget.auth.getUserEmail(),
                            "ordered tours": FieldValue.arrayUnion([]),
                          };
                          widget.database.addNewDocument("Users", userData, widget.auth.getUserID()!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ClientScreen(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,);
                              },
                            ),
                          );
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
      ),
    );
  }
}