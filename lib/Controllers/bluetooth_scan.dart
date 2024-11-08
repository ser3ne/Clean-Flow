// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Widgets/custom_text.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScan extends StatefulWidget {
  const BluetoothScan({super.key, required this.mac});

  final String mac;
  @override
  State<BluetoothScan> createState() => _BluetoothScanState();
}

/*

No, This is not the page where we start scanning
this is the page where we process the results of
the scanning.

the startscan() is int the controller.dart

*/

class _BluetoothScanState extends State<BluetoothScan> {
  bool canINowGoToAnotherPagePlease = false;

  Future<bool> yes(BluetoothDevice device) async {
    var sub = BluetoothController().bluetoothConnectState(device);
    //disconnect and remove all currently connected devices from connected devices List
    if (connectedDevices.contains(device)) {
      await device.disconnect();
      connectedDevices.clear();
      await sub.cancel();
    } else {
      await device.connect();
      if (device.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Successfully Connected to: ${device.platformName.isEmpty ? "Unknown Device" : device.platformName}"),
          ),
        );
        setState(() {
          connectedDevices.add(device); //take device
          canINowGoToAnotherPagePlease = true;
        });
      } else {
        yes(device);
      }
    }
    return canINowGoToAnotherPagePlease;
  }

  Future<void> alertDialogue(BluetoothDevice device) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device.platformName.toString()),
        content: Text("Connect to this device?"),
        actions: [
          //No
          MaterialButton(
              color: Colors.lightBlue,
              onPressed: () {
                Navigator.pop(context); //closes the pop-up
              },
              child: Text("No")),
          SizedBox(
            width: 60,
          ),
          //Yes
          MaterialButton(
              color: Colors.lightBlue,
              onPressed: () async {
                bool redirect = await yes(device);
                //if true, pops all pre-ceding pages, then reoutes to new page, essentially refreshing the pages
                if (redirect) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, deviceprofile, (Route<dynamic> route) => false,
                      arguments: PairArguments(device, device.platformName,
                          device.remoteId.toString()));
                }
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBluePlus.scanResults,
      //this is where we put the results
      initialData: [],
      builder: (context, snapshot) {
        //transfer the data into a more suitable datatype
        //return an empty list if the data is empty
        List<ScanResult> results = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //if we're coming from a saved devices view, this will execute...
        else if (snapshot.hasData &&
            snapshot.data != null &&
            widget.mac != '00') {
          // List<BluetoothDevice> filtered = [];

          if (results.isEmpty) {
            print("Results: $results");
            return Center(
              child: CustomText(
                text: "No Devices Found.\n",
                size: 30,
                fontWeight: FontWeight.w900,
              ),
            );
          }

          //Determine if the scan contained any devices which had out MAC address
          results.any(
            (result) {
              //if it does we go to the profile with all the details
              if (result.device.remoteId.toString() == widget.mac) {
                BluetoothDevice device = result.device;
                Navigator.of(context).pushReplacementNamed(deviceprofile,
                    arguments: PairArguments(device, device.platformName,
                        device.remoteId.toString()));
                return true;
              }
              //if we don't, we don't do anything
              return false;
            },
          );

          // if (device.device.platformName == "Clean-Flow") {
          //   filtered.add(device.device);
          // }

          // if (filtered.isEmpty) {
          //   return Center(
          //     child: Text(
          //       "No Devices Found.\n",
          //       style: TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.w900,
          //       ),
          //     ),
          //   );
          // }
        }
        //if we're normally scanning for devices this will execute
        else if (snapshot.hasData && snapshot.data != null) {
          //Devices
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final device = results[index].device;
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: SizedBox(
                      width: 300,
                      height: 100,
                      //Device Profile Button
                      child: FloatingActionButton(
                        heroTag: index,
                        onPressed: () async {
                          bool isOn =
                              await BluetoothController().checkAdapterState();
                          if (isOn) {
                            alertDialogue(device);
                          } else {}
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Icon(Icons.bluetooth_searching)),
                            Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Device Name: ${device.advName.isEmpty ? device.platformName : device.advName}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text("Device ID: ${device.remoteId}",
                                          overflow: TextOverflow.ellipsis),
                                      Text(
                                          "AdvName: ${device.advName.isEmpty ? "None" : device.advName}",
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )),
                ),
              );
            },
          );
          //Devices end
        }
        return Center(child: Text("Error Scanning Devices."));
      },
    );
  }
}
