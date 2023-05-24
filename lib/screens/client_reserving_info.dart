import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

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
  Map<String, dynamic>? reservingInfo;
  Map<String, dynamic>? tourInfo;
  Map<String, dynamic>? userInfo;
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
    setState(() async {
      reservingInfo = await widget.database.getUserInfo(widget.reservingID);
      tourInfo = await widget.database.getInfoByReference(reservingInfo!["tour"]);
      userInfo = await widget.database.getInfoByReference(reservingInfo!["tour agent"]);
      city = reservingInfo!["city"];
      from = reservingInfo!["from"];
      to = reservingInfo!["to"];
      nights = reservingInfo!["nights"];
      adults = reservingInfo!["adults"];
      children = reservingInfo!["children"];
      currency = reservingInfo!["currency"];
      cost = reservingInfo!["cost"];
      status = reservingInfo!["status"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Інформація про бронювання"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: reservingInfo != null ? Padding(
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text(tourInfo!["name"], style: const TextStyle(fontSize: 15.0),),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text(userInfo!["name"], style: const TextStyle(fontSize: 15.0),),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text(userInfo!["email"], style: const TextStyle(fontSize: 15.0),),
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
                      onPressed: () {
                        Navigator.pop(context);
                        widget.database.deleteDocument("Reservings", widget.reservingID);
                      },
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
      )
          : Container(),
    );
  }
}