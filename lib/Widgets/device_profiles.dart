// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:capstone/homepage/homepage.dart';
import 'package:capstone/miscellaneous/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeviceProfiles extends StatefulWidget {
  const DeviceProfiles({
    super.key,
  });

  @override
  State<DeviceProfiles> createState() => _DeviceProfilesState();
}

class _DeviceProfilesState extends State<DeviceProfiles> {
  bool isSwitch = true;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DeviceArguments;

    String name = args.deviceName.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [Icon(Icons.gamepad)],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(164, 111, 111, 111),
        child: Switch.adaptive(
            value: isSwitch,
            //value = true
            //isSwitch = false
            onChanged: (bool value) {
              setState(() {
                isSwitch = value;
                if (isSwitch == false) {
                  args.device.disconnect();
                  print("Disconnected from Profile");
                  Navigator.pop(context);
                }
              });
            }),
      ),
    );
  }
}
