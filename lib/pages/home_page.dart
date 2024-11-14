// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:convert';
import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/Widgets/custom_text.dart';
import 'package:capstone/global/routes.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/pages/device_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => Home_StatePage();
}

class Home_StatePage extends State<Home_Page> {
  List<dynamic> savedDevices = [];
  bool tryconnecting = false;

  @override
  void initState() {
    super.initState();
    _loadSavedDevices();
  }

  Future<void> _loadSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('savedDevices');
    if (jsonString != null) {
      setState(() {
        savedDevices = jsonDecode(jsonString);
      });
    }
  }

  void changeState() {
    setState(() {
      tryconnecting = !tryconnecting;
    });
  }

  List<BluetoothDevice> devices = [];

  //Start of Bluetooth Stuff Dont mind

  Future<bool> askBluetoothPermission(BluetoothDevice device) async {
    var isOn = await FlutterBluePlus.adapterState.first;
    var state = (isOn == BluetoothAdapterState.on);
    await Permission.bluetooth.request();

    //if bluetooth is off
    if (!state) {
      //prompt user to turn on bluetooth
      await FlutterBluePlus.turnOn();
      isOn = await FlutterBluePlus.adapterState.first;
      state = (isOn == BluetoothAdapterState.on);
      //checks if its on this time
      if (state) {
        //recursion to loop through the function again
        askBluetoothPermission(device);
      }
    }
    //if bluetooth is on
    else {
      await device.connect();
      if (device.isConnected) {
        connectedDevices.add(device);
        Navigator.pushNamedAndRemoveUntil(
            context, deviceprofile, (Route<dynamic> route) => false,
            arguments: PairArguments(
                device, device.platformName, device.remoteId.toString()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Successfully Connected to: ${device.platformName.isEmpty ? "Unknown Device" : device.platformName}"),
        ));
      }
    }
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 0,
                color: Color.fromARGB(0, 255, 255, 255),
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
            gradient: LinearGradient(
              colors: [colorX, colorY],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 30,
                child: Text(
                  "Connected Devices",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            //Dapat Dito sa sizedbox lalabas ung connected Device hindi sa Container
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * .120,
              //checks if there are not connected devices
              child: connectedDevices.isEmpty
                  //true
                  ? Container(
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: const Color.fromARGB(55, 255, 255, 255)),
                      margin: EdgeInsets.only(top: 40),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("No Connected Devices",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                    )
                  //false
                  : FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, deviceprofile,
                            arguments: PairArguments(
                                connectedDevices[0],
                                connectedDevices[0].platformName,
                                connectedDevices[0].remoteId.toString()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              connectedDevices[0].platformName,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          ChevRight(color: Colors.black, size: 45, right: 0)
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.53,
              decoration: BoxDecoration(
                  color: Color.fromARGB(55, 255, 255, 255),
                  borderRadius: BorderRadius.circular(40)),
              //ListView for Saved Devices
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Saved Devices",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ListView.builder(
                        itemCount:
                            savedDevices.isEmpty ? 1 : savedDevices.length,
                        itemBuilder: (context, index) {
                          //checks if savedDevices list is empty
                          var devices =
                              savedDevices.isEmpty ? 0 : savedDevices[index];
                          return savedDevices.isEmpty
                              //Sets "No Device" text if it is
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 235),
                                  child: Center(
                                      child: CustomText(
                                          text: "No Devices",
                                          size: 30,
                                          fontWeight: FontWeight.w900)),
                                )
                              //Takes from Bookmarked if any
                              //This will build all devices "CURRENTLY" saved but not connected
                              : DeviceOverview(
                                  deviceMac: devices['mac'],
                                  platformName: devices['pfname'],
                                  function: changeState,
                                );
                        },
                      ),
                    ),
                  ),
                  tryconnecting
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
