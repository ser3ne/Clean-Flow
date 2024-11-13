// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

/*

Fix Navigation bug
need to stop the duplication

 */
class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = false;
  bool autoConn = false;

  //When the Device is found we navigate to the profile
  void goToProfile() async {
    for (var dev in copyResult) {
      //we'll check all the result if the devices in it contains our mac address
      if (dev.remoteId.toString() == widget.deviceMac) {
        BluetoothDevice device = dev;
        //we'll check if the device is already connected
        if (device.isConnected) {
          //we'll essentially refresh the list of display
          //then navigate to the profile
          connectedDevices.clear();
          connectedDevices.add(device);
          Navigator.pushNamed(context, deviceprofile,
              arguments: PairArguments(
                  device, device.platformName, device.remoteId.toString()));
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
          } else {
            //get a snackbar
          }
        }
      } else {
        //replace with a snackbar
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
