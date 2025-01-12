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
  List<dynamic> filteredDataTable = [];
  List<dynamic> filteredDataChart = [];
  double headerSize = 8;

  final List<String> monthNames = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
  ];
  final List<String> yearNames = ["2025", "2026"];

  int monthIndex = 1;
  int yearIndex = 1;
  String monthText = "JANUARY";
  String yearText = "2025";

  Future<void> _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('historicalData');
    if (jsonString != null) {
      setState(() {
        historicalData = jsonDecode(jsonString);
        _filterDataTable();
        _filterDataChart(monthIndex.toString(), yearText);
      });
    }
  }

  void _filterDataTable() {
    setState(() {
      filteredDataTable =
          historicalData.where((data) => data['name'] == widget.name).toList();
    });
  }

  void _filterDataChart(String month, String year) {
    debugPrint("_filterDataChart: $month");
    setState(() {
      filteredDataChart = historicalData
          .where((data) =>
              data['name'] == widget.name &&
              data['month'] == month &&
              data['year'] == year)
          .toList();
    });
  }

  void _changeMonthTextAndIndex(int month) {
    setState(() {
      monthText = monthNames[month - 1];
      monthIndex = month;
    });
    debugPrint(
        "monthName: ${monthNames[month]} | MonthText: $monthText | Month: $month | MonthIndex: $monthIndex");
    _filterDataChart(month.toString(), yearText);
  }

  void _changeYearTextAndIndex(int year) {
    setState(() {
      yearText = yearNames[year];
      yearIndex = year;
    });
    _filterDataChart(monthIndex.toString(), yearText);
  }

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
    _changeMonthTextAndIndex(monthIndex);
    // _changeYearTextAndIndex(yearIndex);
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Table
                        filteredDataTable.isEmpty
                            ? Center(
                                child: Text("No Data Available"),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                ),
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
                                            ...filteredDataTable.map(
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

                        //Dropdown and Line Graph
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                // border: Border.all(width: 1),
                                ),
                            height: MediaQuery.of(context).size.height * .49,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 2,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      // border: Border.all(width: 1),
                                      // color: Colors.orange
                                      ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //Month DropDown Menu
                                      DropdownMenu(
                                          onSelected: (value) {
                                            _changeMonthTextAndIndex(value!);
                                          },
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          initialSelection: 0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .36,
                                          label: Text("Month"),
                                          dropdownMenuEntries: <DropdownMenuEntry<
                                              int>>[
                                            DropdownMenuEntry(
                                                value: 1, label: "JANUARY"),
                                            DropdownMenuEntry(
                                                value: 2, label: "FEBRUARY"),
                                            DropdownMenuEntry(
                                                value: 3, label: "MARCH"),
                                            DropdownMenuEntry(
                                                value: 4, label: "APRIL"),
                                            DropdownMenuEntry(
                                                value: 5, label: "MAY"),
                                            DropdownMenuEntry(
                                                value: 6, label: "JUNE"),
                                            DropdownMenuEntry(
                                                value: 7, label: "JULY"),
                                            DropdownMenuEntry(
                                                value: 8, label: "AUGUST"),
                                            DropdownMenuEntry(
                                                value: 9, label: "SEPTEMBER"),
                                            DropdownMenuEntry(
                                                value: 10, label: "OCTOBER"),
                                            DropdownMenuEntry(
                                                value: 11, label: "NOVEMBER"),
                                            DropdownMenuEntry(
                                                value: 12, label: "DECEMBER"),
                                          ]),
                                      //Year DrowDown Menu
                                      DropdownMenu(
                                          onSelected: (value) {
                                            _changeYearTextAndIndex(value!);
                                          },
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          initialSelection: 0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .28,
                                          label: Text("Year"),
                                          dropdownMenuEntries: <DropdownMenuEntry<
                                              int>>[
                                            DropdownMenuEntry(
                                                value: 0, label: "2025"),
                                            DropdownMenuEntry(
                                                value: 1, label: "2026")
                                          ])
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text("$monthText, $yearText"),
                                ),
                                //Line Graph
                                filteredDataChart.isEmpty
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .1,
                                        child: Center(
                                          child:
                                              Text("No Chart Data Available"),
                                        ),
                                      )
                                    : CustomChart(
                                        name: widget.name, //String
                                        highColor: Colors.red, //Color
                                        lowColor: Colors.blue, //Color
                                        isCurved: false, //boolean
                                        barWidth: 2.0, //double
                                        dnt: filteredDataChart,
                                      ),
                                Center(
                                  child: filteredDataChart.isEmpty
                                      ? SizedBox.shrink()
                                      : Text("DAYS"),
                                )
                              ],
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
