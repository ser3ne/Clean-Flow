// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, camel_case_types, unnecessary_null_comparison

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Controllers/bluetooth_scan.dart';
import 'package:capstone/global/args.dart';
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
                child: BluetoothScan(mac: "normalscan"),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
