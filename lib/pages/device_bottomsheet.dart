// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously
import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceBottomSheet extends StatefulWidget {
  const DeviceBottomSheet({
    super.key,
  });
  //No parameters for taking in bluetooth device, so we use globaldevice
  @override
  State<DeviceBottomSheet> createState() => _DeviceBottomSheetState();
}

class _DeviceBottomSheetState extends State<DeviceBottomSheet> {
  bool isSwitch = false;
  String platformName = globalDevice!.platformName;
  bool canINowGoToAnotherPagePlease = false;

  Future<bool> yes() async {
    int? x;
    print("iteration: $x");
    var sub = BluetoothController().bluetoothConnectState();
    //disconnect and remove all currently connected devices from connected devices List
    if (connectedDevices.contains(globalDevice)) {
      await globalDevice!.disconnect();
      connectedDevices.clear();
      await sub.cancel();
    } else {
      await globalDevice!.connect();
      if (globalDevice!.isConnected) {
        print(
            "Latest Connection State: ${globalDevice!.isConnected.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Successfully Connected to: ${globalDevice!.platformName.isEmpty ? "Unknown Device" : globalDevice!.platformName}"),
          ),
        );
        setState(() {
          connectedDevices.add(globalDevice!); //take device
          canINowGoToAnotherPagePlease = true;
        });
      } else {
        x = x! + 1;
        yes();
      }
    }
    return canINowGoToAnotherPagePlease;
  }

  @override
  Widget build(BuildContext context) {
    // String remoteId = device!.remoteId.toString();
    return Container(
        margin: EdgeInsets.all(20),
        height: 250,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Text(
                //Device Name
                globalDevice!.advName.isEmpty
                    ? globalDevice!.platformName
                    : globalDevice!.advName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                softWrap: true, textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Connect to this device?"),
                  Switch(
                      activeColor: Colors.white,
                      activeTrackColor: Colors.blueAccent,
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
                                //No
                                MaterialButton(
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      setState(() {
                                        isSwitch = false;
                                      });
                                      Navigator.pop(
                                          context); //closes the pop-up
                                    },
                                    child: Text("No")),
                                SizedBox(
                                  width: 60,
                                ),
                                //Yes
                                MaterialButton(
                                    color: Colors.lightBlue,
                                    onPressed: () async {
                                      bool redirect = await yes();
                                      //if true, pops all pre-ceding pages, then reoutes to new page, essentially refreshing the pages
                                      if (redirect) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            deviceprofile,
                                            (Route<dynamic> route) => false,
                                            arguments: PairArguments(
                                                globalDevice!, 15));
                                      }
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
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Dismiss"),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
