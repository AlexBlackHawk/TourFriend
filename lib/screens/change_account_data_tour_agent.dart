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

enum Sex { male, female }

class ChangeAccountDataTourAgent extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String userID;
  const ChangeAccountDataTourAgent({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.userID});

  @override
  State<ChangeAccountDataTourAgent> createState() => _ChangeAccountDataTourAgentState();
}

class _ChangeAccountDataTourAgentState extends State<ChangeAccountDataTourAgent> {
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
  Timestamp? birthday;
  String? phone;
  String? email;
  String? sex;
  String? photo;
  String? tourCompany;
  late Future<List<DropdownMenuItem<String>>> travelCompan;

  File? imageFile;

  String? imagePath;
  DateTime? pickedDate;

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
    travelCompan = travelCompaniesDropdown();
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
      appBar: AppBar(
        title: const Text("ghbjlmk"),
      ),
      backgroundColor: Colors.grey.shade300,
      body: FutureBuilder<Map<String, dynamic>>(
        future: userInfo,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            photo = snapshot.data!["photo"];
            name = snapshot.data!["name"];
            birthday = snapshot.data!["birthday"];
            phone = snapshot.data!["phone"];
            email = snapshot.data!["email"];
            sex = snapshot.data!["sex"];
            tourCompany = snapshot.data!["tour company"];
            _option = getSexOption(sex!);

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
                          initialValue: name!,
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
                          initialValue: birthday != null ? intl.DateFormat('dd-MM-yyyy').format(birthday!.toDate()) : "",
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
                                context: context, initialDate: birthday != null ? birthday!.toDate() : DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
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
                          initialValue: phone!,
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
                          initialValue: email,
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
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Туристичне агентство",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<List<DropdownMenuItem<String>>>(
                          future: travelCompan,
                          builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
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
                                  validator: (value) => value == null ? "Туристичне агентство" : null,
                                  dropdownColor: Colors.white,
                                  value: tourCompany,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      tourCompany = newValue!;
                                    });
                                  },
                                  items: snapshot.data
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
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
                            {
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
                                "birthday": pickedDate != null ? Timestamp.fromDate(pickedDate!) : null,
                                "name": nameController.text,
                                "sex": userSex,
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

  Future<List<String>> travelCompanies() async {
    return await widget.database.getAllTourCompanies();
  }

  Future<List<DropdownMenuItem<String>>> travelCompaniesDropdown() async {
    List<String> travComp = await travelCompanies();
    return travComp.map<DropdownMenuItem<String>>((String company) => DropdownMenuItem<String>(
      value: company,
      child: Text(
        company,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color:Colors.black
        ),
      ),
    )).toList();
  }
}
