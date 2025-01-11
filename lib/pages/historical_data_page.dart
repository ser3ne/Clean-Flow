// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:capstone/Widgets/custom_chart.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalDataPage extends StatefulWidget {
  const HistoricalDataPage({super.key, required this.name});

  final String name;

  @override
  State<HistoricalDataPage> createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage> {
  List<dynamic> historicalData = [];
  List<dynamic> filteredData = [];
  List<dynamic> filteredDataX2 = [];
  double headerSize = 8;

  Future<void> _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('historicalData');
    if (jsonString != null) {
      setState(() {
        historicalData = jsonDecode(jsonString);
        _filterData();
      });
    }
  }

  void _filterData() {
    setState(() {
      filteredData =
          historicalData.where((data) => data['name'] == widget.name).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  Widget build(BuildContext context) {
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
                        filteredData.isEmpty
                            ? Center(
                                child: Text("No Data Available"),
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(border: Border.all(width: 2)),
                                child: Column(
                                  children: [
                                    //Table Header
                                    Table(
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            children: [
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text("DATE & TIME",
                                                        style: TextStyle(
                                                            fontSize:
                                                                headerSize),
                                                        textAlign:
                                                            TextAlign.center),
                                                  )),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "VOLTAGE",
                                                      style: TextStyle(
                                                          fontSize: headerSize),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "HIGHEST",
                                                      style: TextStyle(
                                                          fontSize: headerSize),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text("LOWEST",
                                                        style: TextStyle(
                                                            fontSize:
                                                                headerSize),
                                                        textAlign:
                                                            TextAlign.center),
                                                  )),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "REDUCED %",
                                                      style: TextStyle(
                                                          fontSize: headerSize),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ))
                                            ]),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.327,
                                      child: SingleChildScrollView(
                                        child: Table(
                                          border: TableBorder.all(
                                              color: Colors.black),
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            //Table Contents
                                            ...filteredData.map(
                                              (data) {
                                                debugPrint(
                                                    "Table Day: ${data['day']}\t:\t${data['day'].runtimeType}");
                                                return TableRow(
                                                  children: [
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${data['year']}/${data['month']}/${data['day']}\n${data['hour']}:${data['minute']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${data['voltage']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${data['high']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${data['low']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          "${data['perc']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
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
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 280,
                                width: 700,
                                child: CustomChart(
                                  name: widget.name, //String
                                  highColor: Colors.red, //Color
                                  lowColor: Colors.blue, //Color
                                  isCurved: false, //boolean
                                  barWidth: 2.0, //double
                                  dnt: filteredData,
                                ),
                              ),
                            ),
                          ),
                        ),
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
