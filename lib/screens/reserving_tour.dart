import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'package:travel_agency_work_optimization/screens/start_screen.dart';

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
  late Future<Map<String, dynamic>> tourInfo;
  String? selectedCurrency;
  int? nights;
  int? adults;
  int? children;
  DocumentReference? tourAgent;
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

  int daysBetween(String fromDate, String toDate) {
    DateTime from = DateTime.parse(fromDate);
    DateTime to = DateTime.parse(toDate);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  void initState() {
    super.initState();
    tourInfo = widget.database.getTourInfo(widget.tourID);
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
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Бронювання"),
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
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: tourInfo,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            tourAgent = snapshot.data!["tour agent"];
            // print(snapshot.data!["price UAH"].toDouble());
            // print(snapshot.data!["price UAH"].runtimeType);
            prices = {
              "Гривні": snapshot.data!["price UAH"].toDouble(),
              "Долари": snapshot.data!["price USD"].toDouble(),
              "Євро": snapshot.data!["price EUR"].toDouble()
            };

            return SingleChildScrollView(
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
                          // onSubmitted: (String val) {
                          //   setState(() {
                          //     if (dateToController.text.isNotEmpty) {
                          //       nights = daysBetween(dateFromController.text, dateToController.text) - 1;
                          //       print(nights);
                          //     }
                          //     if (selectedCurrency != null) {
                          //       cost = nights! * prices![selectedCurrency!]!;
                          //       print(cost);
                          //     }
                          //   });
                          // },
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
                                firstDate: DateTime(2023), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = intl.DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                dateFromController.text = formattedDate; //set output date to TextField value.
                                nights = daysBetween(dateFromController.text, dateToController.text) - 1;
                                cost = nights! * prices![selectedCurrency!]!;
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
                          // onSubmitted: (String val) {
                          //   setState(() {
                          //     if (dateFromController.text.isNotEmpty) {
                          //       nights = daysBetween(dateFromController.text, dateToController.text) - 1;
                          //     }
                          //     if (selectedCurrency != null) {
                          //       cost = nights! * prices![selectedCurrency!]!;
                          //     }
                          //   });
                          // },
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
                                firstDate: DateTime(2023), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = intl.DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                dateToController.text = formattedDate; //set output date to TextField value.
                                if (dateFromController.text.isNotEmpty) {
                                  nights = daysBetween(dateFromController.text, dateToController.text) - 1;
                                }
                                if (selectedCurrency != null) {
                                  cost = nights! * prices![selectedCurrency!]!;
                                }
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

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nights != null ? "Ночей: $nights" : "Ночей: ",
                        style: const TextStyle(
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
                          onChanged: (value) => adults = value.toInt(),
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
                          onChanged: (value) => children = value.toInt(),
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
                                if (nights != null) {
                                  cost = nights! * prices![selectedCurrency!]!;
                                }
                              });
                            },
                            items: currenciesDropdown()
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        cost != null ? "Вартість: $cost" : "Вартість: ",
                        style: const TextStyle(
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
                          onPressed: () async {

                            String userID = widget.auth.user!.uid;
                            String tourID = widget.tourID;

                            Map<String, dynamic> reserveParameters = <String, dynamic>{
                              "client": widget.database.db.doc("Users/$userID"),
                              "tour agent": snapshot.data!["tour agent"],
                              "city": departureCityController.text,
                              "from": dateFromController.text,
                              "to": dateToController.text,
                              "nights": nights,
                              "adults": adults,
                              "children": children,
                              "currency": selectedCurrency,
                              "cost": cost,
                              "tour": widget.database.db.doc("Tours/$tourID"),
                              "status": "Не підтверджено",
                            };
                            String newID = await widget.database.addNewDocument("Reservations", reserveParameters);
                            DocumentReference docRef = widget.database.db.doc("Reservations/$newID");
                            widget.database.updateDocumentData("Users", widget.auth.user!.uid, {"ordered tours": FieldValue.arrayUnion([docRef])});
                            widget.database.updateDocumentData("Users", tourAgent!.id, {"ordered tours": FieldValue.arrayUnion([docRef])});

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