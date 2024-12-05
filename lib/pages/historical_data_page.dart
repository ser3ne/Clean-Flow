// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:capstone/Widgets/dummy.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';

class HistoricalDataPage extends StatefulWidget {
  const HistoricalDataPage({super.key});

  @override
  State<HistoricalDataPage> createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage> {
  @override
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
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.black),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.white),
                              children: [
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("DATE/TIME",
                                          textAlign: TextAlign.center),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "HIGHEST",
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
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
                        height: MediaQuery.of(context).size.height * 0.327,
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.all(color: Colors.black),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              ...List.generate(
                                30,
                                (index) => TableRow(children: [
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Dummy(index: index + 1)))
                                ]),
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
    );
  }
}
