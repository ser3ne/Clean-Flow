// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:capstone/Controllers/bluetooth_datadisplay.dart';
import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceProfile extends StatefulWidget {
  const DeviceProfile({super.key});

  @override
  State<DeviceProfile> createState() => _DeviceProfileState();
}

class _DeviceProfileState extends State<DeviceProfile> {
  Future<void> _savedDevices(
      BuildContext context, String macAdd, String pfName) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('savedDevices');
    List<dynamic> savedDevices =
        jsonString != null ? jsonDecode(jsonString) : [];

    //Searches savedDevices list for any hits for device['mac']
    //returns true if it exists
    bool deviceExists = savedDevices.any(
      (device) => device['mac'] == macAdd,
    );

    //If there aren't any hits,
    //Add the mac address with the name to the saved devices
    if (!deviceExists) {
      savedDevices.add({'mac': macAdd, 'pfname': pfName});

      await prefs.setString('savedDevices', jsonEncode(savedDevices));

      const snackBar =
          SnackBar(content: Text("Device added to saved devices."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //if there are hits, with the mac address
    else {
      // Remove the existing device by filtering it out
      savedDevices.removeWhere(
          (device) => device['mac'] == macAdd && device['pfname'] == pfName);

      // Save the updated list back to Shared Preferences
      await prefs.setString('savedDevices', jsonEncode(savedDevices));

      // Show a SnackBar to confirm device removal
      const snackBar =
          SnackBar(content: Text("Device removed from saved devices."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    //   const snackBar =
    //       SnackBar(content: Text("Device is already in the saved list."));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  // Future<void> _removeDevice(BluetoothDevice globalDevice) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString('savedDevices');
  //   if (jsonString != null) {
  //     savedDevices
  //         .remove({'Device': globalDevice, 'Name': globalDevice.platformName});

  //     await prefs.setString('savedDevices', jsonEncode(savedDevices));

  //     const snackBar = SnackBar(content: Text("Device unsaved."));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  Color color_1 = Color.fromRGBO(255, 255, 255, 1);
  Color color_2 = Color.fromRGBO(194, 193, 216, 1);
  Color color_3 = Color.fromRGBO(140, 138, 184, 1);
  Color color_4 = Color.fromRGBO(83, 80, 139, 1);
  Color color_5 = Color.fromRGBO(54, 50, 124, 1);
  Color color_6 = Color.fromRGBO(18, 15, 69, 1);
  Color color_7 = Color.fromRGBO(0, 0, 0, 1);

  bool isConnected = false;
  String text = "", displayedData = "";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PairArguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_7,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, root, (Route<dynamic> route) => false,
                  arguments: PairArguments(
                      args.device,
                      args.device.platformName,
                      args.device.remoteId.toString()));
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
            )),
        title: Text(
          args.device.platformName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            color_1,
            color_1,
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .42,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 7,
                                color: Color.fromARGB(20, 0, 0, 0),
                                spreadRadius: 3,
                                offset: Offset(0, 5)),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isConnected ? "Saved" : "Tap to Save Device",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            //Make the shared preferences here
                            //currently it does nothing
                            Switch(
                              inactiveTrackColor: Colors.white,
                              activeTrackColor: Colors.blueAccent,
                              inactiveThumbColor: Colors.black,
                              value: isConnected,
                              onChanged: (value) {
                                setState(() {
                                  isConnected = value;
                                });
                                _savedDevices(
                                    context, args.macAddress, args.pfName);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .43,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 7,
                                color: Color.fromARGB(20, 0, 0, 0),
                                spreadRadius: 3,
                                offset: Offset(0, 5)),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Center(
                        //this is where the data goes
                        child: BLEDataDisplay(
                          device: args.device,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1, //10%
                width: MediaQuery.of(context).size.width,
                child: CustomSwitchButtonBig(
                  device: args.device,
                  dialogueText:
                      isConnected ? "Are You Sure?" : "Disconnect Device",
                  size: 55,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
