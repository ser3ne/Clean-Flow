// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceOverview extends StatefulWidget {
  final BluetoothDevice device;
  final String platformName;
  const DeviceOverview(
      {super.key, required this.device, required this.platformName});

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = true;
  Future<void> _savedDevices(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('savedDevices');
    List<dynamic> savedDevices =
        jsonString != null ? jsonDecode(jsonString) : [];

    bool deviceExists = savedDevices.any((device) =>
        device['ID'] == widget.device && device['Name'] == widget.platformName);

    if (!deviceExists) {
      savedDevices.add({'ID': widget.device, 'Name': widget.platformName});

      await prefs.setString('savedDevices', jsonEncode(savedDevices));

      const snackBar = SnackBar(content: Text("Device added."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(content: Text("Device is already saved."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.15,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, deviceprofile,
              arguments: PairArguments(widget.device, 15));
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      widget.device.advName.isEmpty
                          ? widget.device.advName
                          : widget.platformName,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ChevRight(color: Colors.black, size: 50, right: 0)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
