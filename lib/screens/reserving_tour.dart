import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class ReservingTour extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String tourID;
  const ReservingTour({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.tourID});

  @override
  State<ReservingTour> createState() => _ReservingTourState();
}

class _ReservingTourState extends State<ReservingTour> {
  final departureCityController = TextEditingController();
  final dateFromController = TextEditingController();
  final dateToController = TextEditingController();
  Map<String, dynamic>? tourInfo;
  String? selectedCurrency;
  double? nights;
  double? adults;
  double? children;
  Map<String, double>? prices;
  // = {
  //   "Гривні": 900,
  //   "Долари": 1200,
  //   "Євро": 1500
  // };
  double? cost;

  List<String> currencies() {
    return ["Гривні", "Долари", "Євро"];
  }

  List<DropdownMenuItem<String>> currenciesDropdown() {
    List<String> currenc = currencies();
    return currenc.map<DropdownMenuItem<String>>((String company) => DropdownMenuItem<String>(
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

  @override
  void initState() {
    super.initState();
    setState(() {
      tourInfo = widget.database.getTourInfo(widget.tourID);
      prices = {
        "Гривні": tourInfo!["price UAH"],
        "Долари": tourInfo!["price USD"],
        "Євро": tourInfo!["price EUR"]
      };
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    departureCityController.dispose();
    dateFromController.dispose();
    dateToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      backgroundColor: Colors.white,
      body: tourInfo != null ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Місто відправлення",
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
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    cursorColor: Colors.black,
                    controller: departureCityController,
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
                    "Виліт від",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87
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
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    controller: dateFromController,
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = intl.DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateFromController.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "До",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87
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
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    controller: dateToController,
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = intl.DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateToController.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ночей: 5",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color:Colors.black
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Дорослих",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SpinBox(
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    min: 1,
                    max: 100,
                    value: 1,
                    // decoration: InputDecoration(labelText: 'Basic'),
                    onChanged: (value) => adults = value,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),

              // ----------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Дітей",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SpinBox(
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    min: 0,
                    max: 100,
                    value: 0,
                    // decoration: InputDecoration(labelText: 'Basic'),
                    onChanged: (value) => children = value,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Валюта",
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
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null ? "Оберіть валюту" : null,
                      dropdownColor: Colors.white,
                      value: selectedCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                      },
                      items: currenciesDropdown()
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Вартість: 25000",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color:Colors.black
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {

                      String userID = widget.auth.user!.uid;
                      String tourID = widget.tourID;

                      Map<String, dynamic> reserveParameters = <String, dynamic>{
                        "client": widget.database.db.doc("Users/$userID"),
                        "tour agent": tourInfo!["tour agent"],
                        "city": departureCityController.text,
                        "from": dateFromController.text,
                        "to": dateToController.text,
                        "nights": nights,
                        "adults": adults,
                        "children": children,
                        "currency": selectedCurrency,
                        "cost": cost,
                        "tour": widget.database.db.doc("Users/$tourID"),
                        "status": "Не підтверджено",
                      };
                      widget.database.addNewDocument("Reservations", reserveParameters);
                      const snackBar = SnackBar(
                        content: Text('Заявку створено. Очікуйте підтвердження від туристичного агента'),
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
                      'ЗАБРОНЮВАТИ',
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

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: const Text(""),
      backgroundColor: Colors.blue[800],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Назад',
        onPressed: () => Navigator.pushNamed(context, '/client/tour_info'),
      ),
      actions: <Widget>[
        IconButton(onPressed: () => logout(context), icon: const Icon(Icons.logout), tooltip: "Вийти",)
      ],
    );
  }
  void logout(BuildContext context) {
    // Firebase logout
    Navigator.pushNamed(
      context,
      '/',
    );
  }
}