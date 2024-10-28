// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print
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
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DeviceArguments;

    String name = args.deviceName.toString();
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(164, 111, 111, 111),
            child: Center(
              child: Column(
                children: [
                  Text("Connect to device?"),
                  Switch(
                      value: isSwitch,
                      onChanged: (bool value) async {
                        setState(() {
                          isSwitch = value;
                        });
                        if (isSwitch == true) {
                          args.device.connect();
                          await Future.delayed(Duration(milliseconds: 1300));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Connectedd to Device a Successfuly")));
                        }
                      }),
                ],
              ),
            )));
  }
}
