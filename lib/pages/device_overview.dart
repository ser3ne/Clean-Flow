// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class DeviceOverview extends StatefulWidget {
  const DeviceOverview({
    super.key,
    required this.deviceMac,
    required this.platformName,
  });

  final String platformName;
  final String deviceMac;

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = false;

  void goToProfile() async {
    print("results is Empty: ${copyResult.isEmpty}");
    for (var dev in copyResult) {
      if (dev.remoteId.toString() == widget.deviceMac) {
        print("Found");
        BluetoothDevice device = dev;
        if (device.isConnected) {
          connectedDevices.clear();
          connectedDevices.add(device);
          Navigator.pushNamed(context, deviceprofile,
              arguments: PairArguments(
                  device, device.platformName, device.remoteId.toString()));
        } else {
          await device.connect();
          if (device.isConnected) {
            Navigator.pushNamed(context, deviceprofile,
                arguments: PairArguments(
                    device, device.platformName, device.remoteId.toString()));
          } else {
            //get a snackbar
          }
        }
      } else {
        print("Nothing");
      }
    }
  }

  Future<void> confirmConnectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.platformName),
        content: Text("Connect to this device?"),
        actions: [
          //No Option
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
          SizedBox(width: 60),
          //Yes Option
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () async {
              goToProfile();
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Function to navigate to profile under certain conditions

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.12,
      child: FloatingActionButton(
        onPressed: () async {
          //put code here...
          //initatie new Scan for new devices
          confirmConnectionDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.platformName,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isConnected
                        ? Icons.bookmark_added_rounded
                        : Icons.bookmark_remove_outlined,
                    size: 30,
                  )
                ],
              ),
              Switch(
                inactiveTrackColor: Colors.white,
                activeTrackColor: Colors.blueAccent,
                inactiveThumbColor: Colors.black,
                value: isConnected,
                onChanged: (value) {
                  setState(() {
                    isConnected = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
