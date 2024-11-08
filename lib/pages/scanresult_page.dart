// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, camel_case_types, unnecessary_null_comparison

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Controllers/bluetooth_scan.dart';
import 'package:flutter/material.dart';

class Scanresult_Page extends StatefulWidget {
  const Scanresult_Page({super.key});

  @override
  State<Scanresult_Page> createState() => _Scanresult_PageState();
}

class _Scanresult_PageState extends State<Scanresult_Page> {
  Color color_1 = Color.fromRGBO(255, 255, 255, 1);
  Color color_2 = Color.fromRGBO(194, 193, 216, 1);
  Color color_3 = Color.fromRGBO(140, 138, 184, 1);
  Color color_4 = Color.fromRGBO(83, 80, 139, 1);
  Color color_5 = Color.fromRGBO(54, 50, 124, 1);
  Color color_6 = Color.fromRGBO(18, 15, 69, 1);
  Color color_7 = Color.fromRGBO(0, 0, 0, 1);

  bool isScanning = false;
  bool isSwitch = false;
  String mainButtonText = "";

  bool canINowGoToAnotherPagePlease = false;

  void buttonControls(bool isOn) async {
    isSearching(); //disable button
    await BluetoothController()
        .askBluetoothPermission(isOn); //Start Scanning for devices
    isSearching(); //re-enable button
  }

  void init2() async {
    bool isOn = await BluetoothController().checkAdapterState();
    setState(() {
      isOn
          ? mainButtonText = "Scan for device"
          : mainButtonText = "Open Bluetooth";
    });
    //if bluetooth is ON, does a Scan
    //else it asks to turn it on
    buttonControls(isOn);
  }

  @override
  void initState() {
    //checks if bluetooth is on
    init2();
    super.initState();
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
      color: color_1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Drape
            Container(
              //take 80% of device's height resolution
              height: (MediaQuery.of(context).size.height * 0.67),
              //take the device's max width resolution
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  color_1,
                  color_2,
                  color_3,
                  color_4,
                  color_5,
                  color_6,
                  color_7
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(55, 255, 255, 255),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 468, //425
                          width: 300,
                          //Call Scan Results here
                          child: BluetoothScan(
                            mac: '00',
                          ),
                          //Stream end
                        ),
                        Container(
                            // decoration: BoxDecoration(border: Border.all(width: 5)),
                            height: 50,
                            width: 250,
                            child: Center(
                                child: Text(
                              isScanning ? "Searching..." : "Devices",
                              style: TextStyle(
                                  fontSize: isScanning ? 30 : 20,
                                  fontWeight: FontWeight.w900),
                            )))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Drape end
            SizedBox(
              height: 10,
            ),
            //Main Buttton
            SizedBox(
              width: 300,
              child: FloatingActionButton(
                backgroundColor: isScanning
                    ? const Color.fromARGB(255, 179, 221, 255)
                    : Color.fromARGB(255, 37, 157, 255),
                onPressed: isScanning
                    ? null
                    : () async {
                        init2();
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Icon(Icons.bluetooth_searching,
                    //     size: 40,
                    //     color: isScanning
                    //         ? const Color.fromARGB(255, 131, 131, 131)
                    //         : Colors.black),
                    Text(
                      mainButtonText,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isScanning
                              ? const Color.fromARGB(255, 131, 131, 131)
                              : Colors.black),
                    ),
                    Icon(Icons.add_rounded,
                        size: 45,
                        color: isScanning
                            ? const Color.fromARGB(255, 131, 131, 131)
                            : Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
