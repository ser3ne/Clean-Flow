// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:convert';

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/pages/device_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<dynamic> historicalDevices = [];
  Future<void> _historicalDevices(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('historicalDevices');
    historicalDevices = jsonString != null ? jsonDecode(jsonString) : [];

    //Searches savedDevices list for any hits for device['mac']
    //returns true if it exists, false if it doesn't\

    //change this to something more unique
    bool deviceExists = historicalDevices.any(
      (bleDevice) => bleDevice['name'] == device.platformName,
    );

    int autoIncrementID = historicalDevices.isNotEmpty
        ? historicalDevices.map((item) => item['id']).reduce(
              (current, next) => current > next ? current : next,
            )
        : 0;
    autoIncrementID = autoIncrementID + 1;

    //if it doesn't exists, we add
    if (!deviceExists) {
      setState(() {
        historicalDevices.add({
          'id': autoIncrementID,
          'name': device.platformName,
          'mac': device.remoteId.toString(),
          'info': {}
        });
      });

      await prefs.setString('historicalDevices', jsonEncode(historicalDevices));
    }
  }

  bool autoConn = false;
  Future<bool> yes(BluetoothDevice device) async {
    bool canINowGoToAnotherPagePlease = false;
    var sub = BluetoothController().bluetoothConnectState(device);
    //disconnect and remove all currently connected devices from connected devices List
    if (connectedDevices.contains(device)) {
      await device.disconnect();
      setState(() {
        connectedDevices.clear();
      });
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
          //List up the device to the connected devices list
          globalDevice = device;
          connectedDevices.add(device);
          canINowGoToAnotherPagePlease = true;
        });
        Navigator.pop(context);
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
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: double.infinity,
          height: 65,
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.blueAccent),
          child: Center(
            child: Icon(
              Icons.bluetooth_rounded,
              size: 40,
            ),
          ),
        ),
        content: SizedBox(
          height: 147,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Center(
                  child: Text(
                    device.platformName,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    "Connect Device?",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                  )),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "Would you like to connect to this device?",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                print("Device: $device");
                if (redirect) {
                  _historicalDevices(device);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceProfile(
                        args: PairArguments(device, device.platformName,
                            device.remoteId.toString()),
                      ),
                    ),
                  );
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
          // bool isFound = results
          //     .any((element) => element.device.platformName == "Clean-Flow");

          // if (isFound) {
          //   for (var dev in results) {
          //     if (dev.device.platformName == "Clean-Flow") {
          //       filtered.add(dev.device);
          //     }
          //   }
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

          //Devices
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              // final device = filtered[index];
              final device = results[index].device;
              copyResult.add(device);
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
