// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/Widgets/custom_text.dart';
import 'package:capstone/global/routes.dart';
import 'package:capstone/pages/device_overview.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => Home_StatePage();
}

class Home_StatePage extends State<Home_Page> {
  Color color_1 = Color.fromRGBO(255, 255, 255, 1);
  Color color_2 = Color.fromRGBO(194, 193, 216, 1);
  Color color_3 = Color.fromRGBO(140, 138, 184, 1);
  Color color_4 = Color.fromRGBO(83, 80, 139, 1);
  Color color_5 = Color.fromRGBO(54, 50, 124, 1);
  Color color_6 = Color.fromRGBO(18, 15, 69, 1);
  Color color_7 = Color.fromRGBO(0, 0, 0, 1);

  List<BluetoothDevice> devices = [];

  //Start of Bluetooth Stuff Dont mind

  Future<bool> askBluetoothPermission(int index) async {
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
        askBluetoothPermission(index);
      }
    }
    //if bluetooth is on
    else {
      await globalDevice!.connect();
      if (globalDevice!.isConnected) {
        connectedDevices.add(globalDevice!);
        Navigator.pushNamedAndRemoveUntil(
            context, deviceprofile, (Route<dynamic> route) => false,
            arguments: PairArguments(globalDevice!, 15));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Successfully Connected to: ${bookmarked[index].platformName.isEmpty ? "Unknown Device" : bookmarked[index].platformName}"),
        ));
      }
    }
    return state;
  }

  //End of Bluetooth stuff... You can now do whatever you want

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    initPreferences();
    super.initState();
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
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            //Dapat Dito sa sizedbox lalabas ung connected Device hindi sa Container
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * .120,
              child: connectedDevices.isEmpty
                  ? Text("No Connected Devices",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white))
                  : FloatingActionButton(
                      onPressed: () {
                        if (connectedDevices.isNotEmpty) {
                          setState(() {
                            globalDevice = connectedDevices[0];
                          });
                          Navigator.pushNamed(context, deviceprofile,
                              arguments: PairArguments(globalDevice!, 15));
                        }
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
              height: 20,
              child: Text(
                "Saved Devices",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.53,
                decoration: BoxDecoration(
                    color: Color.fromARGB(55, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20)),
                //ListView for Saved Devices (naging bookmarked kasi naming conflicts)
                child: ListView.builder(
                  itemCount: bookmarked.isEmpty ? 1 : bookmarked.length,
                  itemBuilder: (context, index) {
                    return bookmarked.isEmpty
                        //Sets "No Device" text if there aren't any
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
                            device: bookmarked[index],
                            platformName: bookmarked[index].platformName,
                            function: askBluetoothPermission,
                            index: index,
                          );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
