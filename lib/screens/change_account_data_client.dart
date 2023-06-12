import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:travel_agency_work_optimization/screens/start_screen.dart';

enum Sex { male, female }

class ChangeAccountDataClient extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String userID;
  const ChangeAccountDataClient({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.userID});

  @override
  State<ChangeAccountDataClient> createState() => _ChangeAccountDataClientState();
}

class _ChangeAccountDataClientState extends State<ChangeAccountDataClient> {
  String userSex = "Чоловіча";
  Sex? _option; // Write logic
  var sexString = {
    Sex.male : "Чоловіча",
    Sex.female : "Жіноча"
  };

  bool isAvatarChanged = false;

  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late Future<Map<String, dynamic>> userInfo;
  String? name;
  String? birthday;
  String? phone;
  String? email;
  String? sex;
  String? photo;
  DateTime? pickedDate;

  Timestamp? birthdayTS;
  DateTime? birthdayDate;

  File? imageFile;

  String? imagePath;

  Sex getSexOption(String sex) {
    if (sex == "Чоловіча") {
      return Sex.male;
    }
    else {
      return Sex.female;
    }
  }

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
  void initState() {
    super.initState();
    userInfo = widget.database.getUserInfo(widget.userID);
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
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Аккаунт"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const StartScreen();
                    },
                  ),
                );
                widget.auth.userSignOut();
              },
              icon: const Icon(Icons.logout),
              tooltip: "Вийти",
            )
          ],
        ),
      backgroundColor: Colors.grey.shade300,
      body: FutureBuilder<Map<String, dynamic>>(
        future: userInfo,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            photo = snapshot.data!["avatar"];
            name = snapshot.data!["name"];
            birthdayTS = snapshot.data!["birthday"];
            birthdayDate = birthdayTS!.toDate();
            birthday = intl.DateFormat('dd-MM-yyyy').format(birthdayDate!);
            phone = snapshot.data!["phone"];
            email = snapshot.data!["email"];
            sex = snapshot.data!["sex"];
            _option = getSexOption(sex!);

            nameController.text = name!;
            birthdayController.text = birthday!;
            phoneController.text = phone!;
            emailController.text = email!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _getFromGallery();
                        isAvatarChanged = true;
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(photo!),
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
                              color:Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
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
                              color:Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
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
                                context: context, initialDate: birthday != null ? birthdayDate! : DateTime.now(),
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
                                birthdayDate = pickedDate;
                              });
                            }else{
                              print("Date is not selected");
                            }
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
                              color:Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
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
                              color:Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
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
                              color:Colors.black
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
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
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
                                      color:Colors.black
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
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
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
                                      color:Colors.black
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
                              color:Colors.black
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
                              color:Colors.black
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
                            if (passwordController.text != "" || confirmPasswordController.text != "") {
                              if (passwordController.text == confirmPasswordController.text) {
                                widget.auth.updateUserPassword(passwordController.text);
                              }
                              else {

                              }
                            }
                            if (isAvatarChanged) {
                              String fileName = "";
                              String filePath = "";
                              String fileExtension = p.extension(imageFile!.path);
                              String id = widget.userID;
                              fileName = "$id$fileExtension";
                              filePath = "avatars/$id$fileExtension";
                              widget.storage.uploadFile(filePath, imageFile!.path, fileName).then((value) {
                                setState(() {
                                  imagePath = value;
                                });
                              });
                            }
                            else {
                              imagePath = photo;
                            }
                            Map<String, dynamic> userData = <String, dynamic>{
                              "avatar": imagePath,
                              "birthday": Timestamp.fromDate(birthdayDate!),
                              "name": nameController.text,
                              "sex": userSex,
                              "phone": phoneController.text,
                              "email": emailController.text,
                            };
                            widget.auth.updateUserName(nameController.text);
                            widget.auth.updatePhoto(imagePath!);
                            widget.auth.updateUserEmail(emailController.text);
                            widget.database.updateDocumentData("Users", widget.userID, userData);
                            const snackBar = SnackBar(
                              content: Text('Інформацію успішно відредаговано'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                            'ЗБЕРЕГТИ',
                            style: TextStyle(color: Colors.white),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: Column(
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ],
              ),
            );
          }
        },
      )
    );
  }
}
