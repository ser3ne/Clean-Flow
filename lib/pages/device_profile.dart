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
  bool autoConn = false;
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
  }

  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PairArguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, root,
                  arguments: PairArguments(
                      args.device,
                      args.device.platformName,
                      args.device.remoteId.toString()));
            },
            icon: Icon(Icons.chevron_left_outlined)),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [colorX, colorY],
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
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                child: Container(
                  height: MediaQuery.of(context).size.height * .75, //.3
                  width: MediaQuery.of(context).size.width * .9, //.42
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 7,
                            color: Color.fromARGB(20, 0, 0, 0),
                            spreadRadius: 3,
                            offset: Offset(0, 5)),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(98, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .07,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    args.device.platformName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                              //Make the shared preferences here
                              //currently it does nothing
                              Align(
                                alignment: Alignment.topLeft,
                                child: Switch(
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
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.width * .43,
                                child: Center(
                                  //this is where the data goes
                                  child: BLEDataDisplay(
                                    device: args.device,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
