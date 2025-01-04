// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors

import 'dart:convert';

import 'package:capstone/global/args.dart';
import 'package:capstone/pages/historical_data_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalDevicesPage extends StatefulWidget {
  const HistoricalDevicesPage({super.key, required this.deviceName});

  final String deviceName;

  @override
  State<HistoricalDevicesPage> createState() => HhistoricalDStateevicesPage();
}

class HhistoricalDStateevicesPage extends State<HistoricalDevicesPage> {
  List<dynamic> historicalDevices = [];

  Future<void> _loadHistoricalDevices() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('historicalDevices');
    if (jsonString != null) {
      setState(() {
        historicalDevices = jsonDecode(jsonString);
        globalhistoricalDevices.add(historicalDevices);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistoricalDevices();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [colorX, colorY],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(55, 255, 255, 255),
                      Color.fromARGB(55, 255, 255, 255)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(40)),
              //ListView for Saved Devices
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: historicalDevices.isEmpty
                        ? 1
                        : historicalDevices.length,
                    itemBuilder: (context, index) {
                      var device = historicalDevices.isEmpty
                          ? 0
                          : historicalDevices[index];
                      if (historicalDevices.isEmpty ||
                          historicalDevices.isEmpty == "") {
                        return Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text("No Devices History"),
                          ),
                        ));
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: FloatingActionButton(
                          heroTag: index,
                          shape: BeveledRectangleBorder(
                              side: BorderSide(width: 1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoricalDataPage(),
                              ),
                            );
                          },
                          child: Center(child: Text(device['name'])),
                        ),
                      );
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
