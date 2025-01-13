// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, camel_case_types, unnecessary_null_comparison

import 'dart:convert';

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Controllers/bluetooth_scan.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scanresult_Page extends StatefulWidget {
  const Scanresult_Page({super.key});

  @override
  State<Scanresult_Page> createState() => _Scanresult_PageState();
}

class _Scanresult_PageState extends State<Scanresult_Page> {
  List<dynamic> historicalDevices = [];
  List<dynamic> historicalData = [];

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonStringDevices = prefs.getString('historicalDevices');
    String? jsonStringData = prefs.getString('historicalData');
    if (jsonStringDevices != null) {
      setState(() {
        historicalDevices = jsonDecode(jsonStringDevices);
      });
    }
    if (jsonStringData != null) {
      setState(() {
        historicalData = jsonDecode(jsonStringData);
      });
    }
  }

  Future<void> deleteAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: double.infinity,
          height: 65, //65
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.blueAccent),
          child: Center(
            child: Icon(
              Icons.save,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
        content: SizedBox(
          width: 100,
          height: 100, //147
          child: Column(
            children: const [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Remove Saved Data?",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "Which data will you remove?",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  color: Color.fromARGB(255, 60, 193, 255),
                  onPressed: () async {
                    await _clearHistoricalDevices(1);
                    Navigator.pop(context);
                  },
                  child: Text("Devices")),
              MaterialButton(
                  color: Colors.lightBlue,
                  onPressed: () async {
                    await _clearHistoricalDevices(3);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Both",
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  color: Color.fromARGB(255, 60, 193, 255),
                  onPressed: () async {
                    await _clearHistoricalDevices(2);
                    Navigator.pop(context);
                  },
                  child: Text("Data"))
            ],
          )
        ],
      ),
    );
  }

  Future<void> _clearHistoricalDevices(int which) async {
    final prefs = await SharedPreferences.getInstance();
    switch (which) {
      case 1:
        await prefs.remove('historicalDevice');
        setState(() {
          historicalDevices.remove('name');
        });
        break;
      case 2:
        await prefs.remove('historicalData');
        break;
      case 3:
        await prefs.clear();
        break;
      default:
        break;
    }
  }

  bool isScanning = false;
  bool isSwitch = false;
  String mainButtonText = "";

  bool canINowGoToAnotherPagePlease = false;
  //false
  void buttonControls(bool isOn) async {
    isSearching(); //disable button
    print("Disabled in scanresult");
    await BluetoothController()
        .askBluetoothPermission(isOn); //Start Scanning for devices
    print("Permission in scanresult");
    isSearching(); //re-enable button
    print("Enabled in scanresult");
  }

  void init2() async {
    //Checks for bluetooth status (on or off)
    bool isOn = await BluetoothController().checkAdapterState();
    buttonControls(isOn);
  }

  @override
  void initState() {
    //checks if bluetooth is on
    init2();
    super.initState();
    _loadHistory();
  }

  void isSearching() {
    setState(() {
      isScanning = !isScanning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [colorX, colorY],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //disconnect button
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: IconButton(
                  onPressed: globalDevice != null
                      ? () async {
                          var sub = BluetoothController()
                              .bluetoothConnectState(globalDevice!);
                          await globalDevice!.disconnect();
                          await sub.cancel();
                          setState(() {
                            connectedDevices.clear();
                            globalDevice = null;
                          });
                        }
                      : null,
                  icon: Icon(Icons.bluetooth_disabled_rounded,
                      color: globalDevice != null
                          ? Colors.black
                          : Color.fromARGB(56, 0, 0, 0),
                      size: 30),
                ),
              ),
              //clear devices
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: IconButton(
                  onPressed: globalDevice != null
                      ? () async {
                          deleteAlert();
                        }
                      : null,
                  icon: Icon(Icons.remove_circle_outline,
                      color: globalDevice != null
                          ? Colors.black
                          : Color.fromARGB(56, 0, 0, 0),
                      size: 30),
                ),
              ),
              //Scan Button
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: IconButton(
                    onPressed: isScanning
                        ? null
                        : () async {
                            bool isOn =
                                await BluetoothController().checkAdapterState();
                            buttonControls(isOn);
                          },
                    icon: Icon(Icons.sync_sharp,
                        color: isScanning
                            ? Color.fromARGB(56, 0, 0, 0)
                            : Colors.black,
                        size: 30)),
              ),
            ],
          ),
          //Results Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(width: 3),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                //Stream
                child: BluetoothScan(
                  mac: "normalscan",
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
