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
              Text("Connect to device?"),
              Switch(
                  value: isSwitch,
                  onChanged: (bool value) async {
                    setState(() {
                      isSwitch = value;
                    });
                    if (isSwitch == true) {
                      var sub = BluetoothController().bluetoothConnectState();
                      await globalDevice!.connect();
                      if (globalDevice!.isConnected) {
                        print("Conneccted");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Successfully connected to: $platformName"),
                          action: SnackBarAction(
                            label: "Got it",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        print("Not Connected");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Unable to connect to: $platformName"),
                          action: SnackBarAction(
                            label: "Got it",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          duration: Duration(seconds: 2),
                        ));
                        sub.cancel();
                      }
                    }
                  }),
            ],
          ),
        ));
  }
}
