// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print

import 'package:capstone/Controllers/bluetooth_controller.dart';
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

the startscan() is in the controller.dart

*/

class _BluetoothScanState extends State<BluetoothScan> {
  Future<bool> yes(BluetoothDevice device) async {
    bool canINowGoToAnotherPagePlease = false;
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
        print("==========START==========");
        print(
            'Snapshot Data: ${snapshot.hasData}, ${snapshot != null}\nWidget.mac: ${widget.mac}');
        results = snapshot.data ?? [];
        //if Snapshot has no data or is waiting
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        }
        //if we're coming from a Saved Devices/Home Page view, this will execute...
        else if (results.isNotEmpty) {
          // List<BluetoothDevice> filtered = [];
          //Determine if the scan contained any devices which had our MAC address

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

          //if we're normally scanning for devices this will execute

          print("Scan Devices");
          //Devices
          List<ScanResult> results = snapshot.data ?? [];
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
                          }
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
        return SizedBox.shrink();
      },
    );
  }
}
