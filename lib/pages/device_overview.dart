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
    required this.function,
  });

  final String platformName;
  final String deviceMac;
  final VoidCallback function;

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

/*

Fix Navigation bug
need to stop the duplication

 */
class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = false;

  //When the Device is found we navigate to the profile
  void goToProfile(BuildContext context) async {
    for (var dev in copyResult) {
      int counter = 0;
      if (counter != copyResult.length - 1) {
        //we'll check all the result if the devices in it contains our mac address
        if (dev.remoteId.toString() == widget.deviceMac) {
          BluetoothDevice device = dev;
          //we'll check if the device is already connected
          if (device.isConnected) {
            //we'll essentially just navigate to the profile
            connectedDevices.add(device);
            Navigator.pushNamed(context, deviceprofile,
                arguments: PairArguments(
                    device, device.platformName, device.remoteId.toString()));
            break;
          }
          //if we're not already connected, we'll connect to it
          //through the results which is 'device' at this point
          else {
            await device.connect();
            if (device.isConnected) {
              //D0:62:2C:3B:18:5E || smartwatch
              Navigator.pushNamed(context, deviceprofile,
                  arguments: PairArguments(
                      device, device.platformName, device.remoteId.toString()));
              break;
            } else {
              final snackBar = SnackBar(
                  content: Text(
                      "Connected to saved device: ${device.platformName}."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              break;
            }
          }
        }
      } else {
        //replace with a snackbar
        final snackBar = SnackBar(
            content: Text("Did not find device with matching descriptions."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      }
    }
  }

  Future<void> confirmConnectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.platformName),
        content: Text("Connect to Device?"),
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
              goToProfile(context);
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.12,
      child: FloatingActionButton(
        onPressed: () async {
          //the only problem is that we have to scan first
          //then to the connect saved devices, which is very scuffed
          widget.function;
          confirmConnectionDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.platformName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
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
