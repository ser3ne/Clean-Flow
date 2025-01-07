// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:capstone/Widgets/custom_chart.dart';
import 'package:capstone/global/args.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalDataPage extends StatefulWidget {
  const HistoricalDataPage({super.key});

  @override
  State<HistoricalDataPage> createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage> {
  List<dynamic> historicalData = [];
  Future<void> _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('historicalData');
    if (jsonString != null) {
      setState(() {
        historicalData = jsonDecode(jsonString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  Widget build(BuildContext context) {
    List<FlSpot> high = [
      FlSpot(2, 5),
      FlSpot(4, 20),
      FlSpot(6, 30),
      FlSpot(8, 5),
      FlSpot(10, 24),
      FlSpot(12, 2),
    ];
    List<FlSpot> low = [
      FlSpot(1, 28),
      FlSpot(3, 17),
      FlSpot(5, 25),
      FlSpot(7, 0),
      FlSpot(9, 20),
      FlSpot(11, 25),
    ];
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage("assets/cf.png")),
        centerTitle: true,
        title: const Text(
          "History",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w900),
        ),
        actions: [],
        backgroundColor: colorY,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [colorX, colorY],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(55, 255, 255, 255),
                    Color.fromARGB(55, 255, 255, 255)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Table
                        Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 2)),
                          child: Column(
                            children: [
                              Table(
                                border: TableBorder.all(color: Colors.black),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      children: [
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text("DATE/TIME",
                                                  textAlign: TextAlign.center),
                                            )),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "HIGHEST",
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text("LOWEST",
                                                  textAlign: TextAlign.center),
                                            )),
                                      ]),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.327,
                                child: SingleChildScrollView(
                                  child: Table(
                                    border:
                                        TableBorder.all(color: Colors.black),
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      ...List.generate(
                                        30,
                                        (index) => TableRow(children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "${now.day}/${now.month}/${now.year}\n${now.hour}:${now.minute}",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                      "Data ${index + 1} Highest",
                                                      textAlign:
                                                          TextAlign.center))),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                      "Data ${index + 1} Lowest",
                                                      textAlign:
                                                          TextAlign.center)))
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        //Line Graph
                        Container(
                          height: MediaQuery.of(context).size.height * .3,
                          width: MediaQuery.of(context).size.width * 2,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .05),
                          decoration: BoxDecoration(
                              // border: Border.all(width: 2)
                              ),
                          child: SizedBox(
                            width: 400,
                            height: 400,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 250,
                                      width: 300,
                                      child: CustomChart(
                                        high: high,
                                        highColor: Colors.red,
                                        low: low,
                                        lowColor: Colors.blue,
                                        isCurved: false,
                                        barWidth: 2.0,
                                        month: now.month,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 250,
                                      width: 250,
                                      child: CustomChart(
                                        high: high,
                                        highColor: Colors.red,
                                        low: low,
                                        lowColor: Colors.blue,
                                        isCurved: false,
                                        barWidth: 2.0,
                                        month: now.month,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 250,
                                      width: 250,
                                      child: CustomChart(
                                        high: high,
                                        highColor: Colors.red,
                                        low: low,
                                        lowColor: Colors.blue,
                                        isCurved: false,
                                        barWidth: 2.0,
                                        month: now.month,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/**
 CustomChart(
                                      high: high,
                                      highColor: Colors.red,
                                      isCurved: false,
                                      barWidth: 2,
                                      low: low,
                                      lowColor: Colors.blue),
 */
