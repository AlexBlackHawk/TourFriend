import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TourAgentReservingInfo extends StatefulWidget {
  const TourAgentReservingInfo({super.key});

  @override
  State<TourAgentReservingInfo> createState() => _TourAgentReservingInfoState();
}

class _TourAgentReservingInfoState extends State<TourAgentReservingInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("fhgjkl"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
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
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("ПІБ клієнта", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Олег Михайлович Свириденко", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Email", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("sviridol@gmail.com", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Місто відправлення", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Київ", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Виліт від", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("12.03.2023", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("До", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("24.04.2023", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Ночей", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("45", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Дорослих", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("3", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Дітей", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("1", style: TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Валюта", style: TextStyle(fontSize: 15.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 11,
                        ),
                        child: Text("Гривні", style: TextStyle(fontSize: 15.0),),
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
                        child: Text(intl.NumberFormat.simpleCurrency(locale: 'uk_UA').format(45000), style: const TextStyle(fontSize: 15.0),),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      child: const Text(
                        'НАПИСАТИ',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
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
                        'ПІДТВЕРДИТИ БРОНЮВАННЯ',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}