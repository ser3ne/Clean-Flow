// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, camel_case_types, unnecessary_null_comparison

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Widgets/custom_text.dart';
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
  Color color_1 = Color.fromRGBO(119, 117, 241, 1);
  Color color_2 = Color.fromRGBO(69, 66, 250, 1);
  Color color_3 = Color.fromRGBO(26, 25, 68, 1);
  Color color_4 = Color.fromRGBO(2, 1, 34, 1);

  bool isScanning = false;
  bool isSwitch = false;
  String mainButtonText = "";

  void scan() async {
    isSearching(); //disable button
    await BluetoothController().scanDevices(); //Start Scanning for devices
    isSearching(); //re-enable button
  }

  Future<bool> askBluetoothPermission() async {
    var aState = await FlutterBluePlus.adapterState.first;
    var isOn = (aState == BluetoothAdapterState.on);
    await Permission.bluetooth.request();
    print("isOn: $isOn");
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
          mainButtonText = "Connect New Device";
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

  @override
  void initState() {
    //checks if bluetooth is on
    askBluetoothPermission();
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color_1, color_2, color_3, color_4],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
                  border: Border.all(width: 5),
                  gradient: LinearGradient(
                    colors: [color_1, color_2, color_2, color_3, color_4],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
              child: Center(
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
                                        height: 250,
                                        //Device Profile Button
                                        child: FloatingActionButton(
                                          heroTag: index,
                                          onPressed: () async {
                                            setState(() {
                                              globalDevice = device;
                                            });

                                            await showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return DeviceBottomSheet();
                                              },
                                            );
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
                                                        const EdgeInsets.all(5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Device Name: ${device.platformName.isEmpty ? "Unknown Device" : device.platformName}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                            "Device ID: ${device.remoteId}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        Text(
                                                            "Extra Info: ${device.advName.isEmpty ? "--:--" : device.advName}",
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
                        askBluetoothPermission();
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.bluetooth_searching,
                        size: 40,
                        color: isScanning
                            ? const Color.fromARGB(255, 131, 131, 131)
                            : Colors.black),
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
