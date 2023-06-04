import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'package:travel_agency_work_optimization/screens/start_screen.dart';

class ClientReservingInfo extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String reservingID;
  const ClientReservingInfo({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.reservingID});

  @override
  State<ClientReservingInfo> createState() => _ClientReservingInfoState();
}

class _ClientReservingInfoState extends State<ClientReservingInfo> {
  late Future<Map<String, dynamic>> reservingInfo;
  late Future<Map<String, dynamic>> tourInfo;
  late Future<Map<String, dynamic>> userInfo;
  String? city;
  String? from;
  String? to;
  int? nights;
  int? adults;
  int? children;
  String? currency;
  int? cost;
  String? status;

  @override
  void initState() {
    super.initState();
    reservingInfo = widget.database.getReservingInfo(widget.reservingID);
    // setState(() async {
    //   city = reservingInfo!["city"];
    //   from = reservingInfo!["from"];
    //   to = reservingInfo!["to"];
    //   nights = reservingInfo!["nights"];
    //   adults = reservingInfo!["adults"];
    //   children = reservingInfo!["children"];
    //   currency = reservingInfo!["currency"];
    //   cost = reservingInfo!["cost"];
    //   status = reservingInfo!["status"];
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          future: reservingInfo,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              city = snapshot.data!["city"];
              from = snapshot.data!["from"];
              to = snapshot.data!["to"];
              nights = snapshot.data!["nights"];
              adults = snapshot.data!["adults"];
              children = snapshot.data!["children"];
              currency = snapshot.data!["currency"];
              cost = snapshot.data!["cost"];
              status = snapshot.data!["status"];
              tourInfo = widget.database.getInfoByReference(snapshot.data!["tour"]);
              userInfo = widget.database.getInfoByReference(snapshot.data!["tour agent"]);

              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Table(
                          border: TableBorder.all(color: Colors.black, width: 1.5),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Тур", style: TextStyle(fontSize: 15.0),),
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: tourInfo,
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 16,
                                        left: 11,
                                      ),
                                      child: Text(snapshot.data!["name"], style: const TextStyle(fontSize: 15.0),),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text('Error');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("ПІБ клієнта", style: TextStyle(fontSize: 15.0),),
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: userInfo,
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 16,
                                        left: 11,
                                      ),
                                      child: Text(snapshot.data!["name"], style: const TextStyle(fontSize: 15.0),),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text('Error');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Email", style: TextStyle(fontSize: 15.0),),
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: userInfo,
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 16,
                                        left: 11,
                                      ),
                                      child: Text(snapshot.data!["email"], style: const TextStyle(fontSize: 15.0),),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text('Error');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Місто відправлення", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(city!, style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Виліт від", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(from!, style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("До", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(to!, style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Ночей", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(nights!.toString(), style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Дорослих", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(adults!.toString(), style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Дітей", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(children!.toString(), style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Валюта", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(currency!, style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Вартість", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(intl.NumberFormat.simpleCurrency(locale: 'uk_UA').format(cost!.toString()), style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text("Статус", style: TextStyle(fontSize: 15.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                  left: 11,
                                ),
                                child: Text(status!, style: const TextStyle(fontSize: 15.0),),
                              ),
                            ]),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: status == "Не підтверджено" ? () {
                                Navigator.pop(context);
                                widget.database.deleteDocument("Reservings", widget.reservingID);
                              } : null,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              child: const Text(
                                'ВІДМІНИТИ БРОНЮВАННЯ',
                                style: TextStyle(color: Colors.white),
                              )
                          ),
                        ),
                      ],
                    ),
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