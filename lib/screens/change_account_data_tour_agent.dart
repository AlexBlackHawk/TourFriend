import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

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

  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Map<String, dynamic>? userInfo;
  String? name;
  String? birthday;
  String? phone;
  String? email;
  String? sex;
  String? photo;
  String? tourCompany;

  Sex getSexOption(String sex) {
    if (sex == "Чоловіча") {
      return Sex.male;
    }
    else {
      return Sex.female;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userInfo = widget.database.getUserInfo(widget.userID);
      photo = userInfo!["photo"];
      name = userInfo!["name"];
      birthday = userInfo!["birthday"];
      phone = userInfo!["phone"];
      email = userInfo!["email"];
      sex = userInfo!["sex"];
      tourCompany = userInfo!["tour company"];
      _option = getSexOption(sex!);
    });
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
      body: userInfo != null ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){},
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
                    initialValue: birthday,
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
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = intl.DateFormat('dd-MM-yyyy').format(pickedDate);
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
                  DropdownButtonFormField(
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
                      items: travelCompaniesDropdown()
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
                      Navigator.pop(context);
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
      )
      : Container(),
    );
  }

  List<String> travelCompanies() {
    return ["ghbfmcdkls", "cfgvhbjnk", "jnyhbtgvrf", "bhtgrvfd", "bgfvsdc"];
  }

  List<DropdownMenuItem<String>> travelCompaniesDropdown() {
    List<String> travComp = travelCompanies();
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
