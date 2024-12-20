// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:capstone/Controllers/bluetooth_datadisplay.dart';
import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/Widgets/button.dart';
import 'package:capstone/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceProfile extends StatefulWidget {
  const DeviceProfile({super.key, required this.args});
  final PairArguments args;

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
    //returns true if it exists, false if it doesn't
    bool deviceExists = savedDevices.any(
      (device) => device['mac'] == macAdd,
    );

    //If there aren't any hits,
    //Add the mac address with the name to the saved devices
    if (!deviceExists) {
      setState(() {
        savedDevices.add({'mac': macAdd, 'pfname': pfName});
      });

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

  void isThisDeviceSaved() {
    bool deviceExists = savedDevices.any(
      (device) => device['mac'] == widget.args.macAddress,
    );
    if (deviceExists) {
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isThisDeviceSaved();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
              args: HistoricalArguments(widget
                  .args.device.platformName)), // Pass arguments via constructor
        ),
        (Route<dynamic> route) =>
            false, // Condition to remove all previous routes
      ),
      child: Scaffold(
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
              children: [
                //logo top-left
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/cf.png"))),
                      ),
                    ]),
                SizedBox(
                  height: 10,
                ),
                //face of the profile
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .75, //.3
                    width: MediaQuery.of(context).size.width * .9, //.42
                    decoration: BoxDecoration(
                        border: Border.all(width: 3),
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
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Device Name location
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .07,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 3),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      widget.args.device.platformName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Switch(
                                      inactiveTrackColor: Colors.white,
                                      activeTrackColor: Colors.blueAccent,
                                      inactiveThumbColor: Colors.black,
                                      value: isConnected,
                                      onChanged: (value) {
                                        setState(() {
                                          isConnected = value;
                                        });
                                        if (isConnected) {
                                          _savedDevices(
                                              context,
                                              widget.args.macAddress,
                                              widget.args.pfName);
                                        }
                                      },
                                    ),
                                    MyButton()
                                  ],
                                )
                              ],
                            ),
                          ),
                          //display: Chart data and numerical Values
                          Container(
                            // decoration:
                            //     BoxDecoration(border: Border.all(width: 3)),
                            height: 475,
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
                                    device: widget.args.device,
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
                //Custom Disconnect Switch
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1, //10%
                  width: MediaQuery.of(context).size.width,
                  child: CustomSwitchButtonBig(
                    device: widget.args.device,
                    dialogueText:
                        isConnected ? "Are You Sure?" : "Disconnect Device",
                    size: 55,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
