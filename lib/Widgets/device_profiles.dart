// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print
import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';

class DeviceProfiles extends StatefulWidget {
  const DeviceProfiles({
    super.key,
  });

  @override
  State<DeviceProfiles> createState() => _DeviceProfilesState();
}

class _DeviceProfilesState extends State<DeviceProfiles> {
  bool isSwitch = false;
  String platformName = globalDevice!.platformName;

  void yes() async {
    var sub = BluetoothController().bluetoothConnectState();
    //Disconnecting first to make sure connection can be properly established
    await globalDevice!.connect();
    if (globalDevice!.isDisconnected) {
      yes();
    } else {
      print("Latest Connection State: ${globalDevice!.isConnected.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Successfully Connected to: ${globalDevice!.platformName.isEmpty ? "Unknown Device" : globalDevice!.platformName}")));
      setState(() {
        savedDevices.add(globalDevice!);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // String remoteId = device!.remoteId.toString();
    return Container(
        height: 250,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Text(
                globalDevice!.platformName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Connect to this device?"),
                  Switch(
                      activeColor: Colors.green,
                      activeTrackColor: Color.fromARGB(255, 27, 61, 28),
                      value: isSwitch,
                      onChanged: (bool value) async {
                        setState(() {
                          isSwitch = value;
                        });
                        if (isSwitch == true) {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text(globalDevice!.platformName.toString()),
                              content: Text("Connect to this device?"),
                              actions: [
                                MaterialButton(
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      setState(() {
                                        isSwitch = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                                SizedBox(
                                  width: 60,
                                ),
                                MaterialButton(
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      yes();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          );
                        }
                      })
                ],
              )
            ],
          ),
        ));
  }
}
