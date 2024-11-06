// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, camel_case_types, unnecessary_null_comparison

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/pages/device_bottomsheet.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Scanresult_Page extends StatefulWidget {
  const Scanresult_Page({super.key});

  @override
  State<Scanresult_Page> createState() => _Scanresult_PageState();
}

class _Scanresult_PageState extends State<Scanresult_Page> {
  Color color_1 = Color.fromRGBO(255, 255, 255, 1);
  Color color_2 = Color.fromRGBO(194, 193, 216, 1);
  Color color_3 = Color.fromRGBO(140, 138, 184, 1);
  Color color_4 = Color.fromRGBO(83, 80, 139, 1);
  Color color_5 = Color.fromRGBO(54, 50, 124, 1);
  Color color_6 = Color.fromRGBO(18, 15, 69, 1);
  Color color_7 = Color.fromRGBO(0, 0, 0, 1);

  bool isScanning = false;
  bool isSwitch = false;
  String mainButtonText = "";

  void scan() async {
    isSearching(); //disable button
    await BluetoothController().scanDevices(); //Start Scanning for devices
    isSearching(); //re-enable button
  }

  Future<bool> askBluetoothPermission(bool state) async {
    bool isOn = state;
    //if bluetooth is off
    if (!isOn) {
      setState(() {
        mainButtonText = "Open Bluetooth";
      });
      //prompt user to turn on bluetooth
      await FlutterBluePlus.turnOn();

      //if bluetooth is on
      if (isOn) {
        setState(() {
          mainButtonText = "Scan for Devices";
        });
        scan();
      }
      // if bluetooth is off
      else if (!isOn) {
        setState(() {
          mainButtonText = "Open Bluetooth";
        });
      }
    }
    //if bluetooth is on
    else {
      setState(() {
        mainButtonText = "Connect New Device";
      });
      scan();
    }
    return isOn;
  }

  Future<bool> checkAdapterState() async {
    var aState = await FlutterBluePlus.adapterState.first;
    var isOn = (aState == BluetoothAdapterState.on);
    await Permission.bluetooth.request();
    askBluetoothPermission(isOn);
    return isOn;
  }

  void init2() {
    bool isOn = true;
    if (isOn == checkAdapterState()) {
      askBluetoothPermission(isOn);
    }
  }

  @override
  void initState() {
    //checks if bluetooth is on
    init2();
    super.initState();
  }

  void isSearching() {
    setState(() {
      isScanning = !isScanning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: color_1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Drape
            Container(
              //take 80% of device's height resolution
              height: (MediaQuery.of(context).size.height * 0.67),
              //take the device's max width resolution
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  color_1,
                  color_2,
                  color_3,
                  color_4,
                  color_5,
                  color_6,
                  color_7
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(55, 255, 255, 255),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 475, //425
                          width: 300,
                          //put Stream here xd
                          child: StreamBuilder<List<ScanResult>>(
                            stream: FlutterBluePlus.scanResults,
                            initialData: [],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                print(
                                    "Snapshot State: ${snapshot.connectionState}\n");
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                List<ScanResult> results = snapshot.data ?? [];
                                // List<BluetoothDevice> filtered = [];
                                print('Snapshot Data: ${snapshot.data}\n');

                                // if (results.isEmpty) {
                                //   print("Results: $results");
                                //   return Center(
                                //     child: CustomText(
                                //       text: "No Devices Found.\n",
                                //       size: 30,
                                //       fontWeight: FontWeight.w900,
                                //     ),
                                //   );
                                // }
                                // for (ScanResult device in results) {
                                //   if (device.device.platformName == "Clean-Flow") {
                                //     filtered.add(device.device);
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
                                    final device = results[index].device;
                                    return Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: SizedBox(
                                            width: 300,
                                            height: 100,
                                            //Device Profile Button
                                            child: FloatingActionButton(
                                              heroTag: index,
                                              onPressed: () async {
                                                bool isOn =
                                                    await checkAdapterState();
                                                if (isOn) {
                                                  setState(() {
                                                    globalDevice = device;
                                                  });

                                                  await showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.white,
                                                    context: context,
                                                    builder: (context) {
                                                      return DeviceBottomSheet();
                                                    },
                                                  );
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Icon(Icons
                                                          .bluetooth_searching)),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Device Name: ${device.advName.isEmpty ? device.platformName : device.advName}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                                "Device ID: ${device.remoteId}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            Text(
                                                                "AdvName: ${device.advName.isEmpty ? "None" : device.advName}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
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
                              } else {
                                return Center(
                                    child: Text("Error Scanning Devices."));
                              }
                            },
                          ),
                          //Stream end
                        ),
                        Container(
                            // decoration: BoxDecoration(border: Border.all(width: 5)),
                            height: 50,
                            width: 250,
                            child: Center(
                                child: Text(
                              isScanning ? "Searching..." : "Devices",
                              style: TextStyle(
                                  fontSize: isScanning ? 30 : 20,
                                  fontWeight: FontWeight.w900),
                            )))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Drape end
            SizedBox(
              height: 10,
            ),
            //Main Buttton
            SizedBox(
              width: 300,
              child: FloatingActionButton(
                backgroundColor: isScanning
                    ? const Color.fromARGB(255, 179, 221, 255)
                    : Color.fromARGB(255, 37, 157, 255),
                onPressed: isScanning
                    ? null
                    : () async {
                        bool isOn = await checkAdapterState();
                        if (isOn) {
                          await askBluetoothPermission(isOn);
                        }
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Icon(Icons.bluetooth_searching,
                    //     size: 40,
                    //     color: isScanning
                    //         ? const Color.fromARGB(255, 131, 131, 131)
                    //         : Colors.black),
                    Text(
                      mainButtonText,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isScanning
                              ? const Color.fromARGB(255, 131, 131, 131)
                              : Colors.black),
                    ),
                    Icon(Icons.add_rounded,
                        size: 45,
                        color: isScanning
                            ? const Color.fromARGB(255, 131, 131, 131)
                            : Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
