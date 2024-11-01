// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';

class DeviceBottomSheet extends StatefulWidget {
  const DeviceBottomSheet({
    super.key,
  });

  @override
  State<DeviceBottomSheet> createState() => _DeviceBottomSheetState();
}

class _DeviceBottomSheetState extends State<DeviceBottomSheet> {
  bool isSwitch = false;
  String platformName = globalDevice!.platformName;
  bool canINowGoToAnotherPagePlease = false;

  Future<void> yes() async {
    await globalDevice!.connect();
    if (globalDevice!.isConnected) {
      print("Latest Connection State: ${globalDevice!.isConnected.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Successfully Connected to: ${globalDevice!.platformName.isEmpty ? "Unknown Device" : globalDevice!.platformName}")));
      setState(() {
        connectedDevices.add(globalDevice!);
      });
      Navigator.pop(context);
      setState(() {
        canINowGoToAnotherPagePlease = true;
      });
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
                                    onPressed: () async {
                                      await yes();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          );
                          if (canINowGoToAnotherPagePlease) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, root, (Route<dynamic> route) => false);
                          } else {
                            setState(() {
                              isSwitch = false;
                            });
                          }
                        }
                      })
                ],
              )
            ],
          ),
        ));
  }
}
