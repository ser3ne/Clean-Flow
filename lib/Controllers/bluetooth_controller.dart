// ignore_for_file: avoid_print, prefer_const_constructors, collection_methods_unrelated_type

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController {
  //This tells the app to target all ESP32 with this service uuid
  Guid targetServiceUUID = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");

  // Checks if bluetooth is ON or OFF
  //returns true if ON, else it's false
  Future<bool> checkAdapterState() async {
    // Check each permission and log the result
    var bluetoothPermission = await Permission.bluetooth.status;
    print('Bluetooth Permission Status: $bluetoothPermission');
    if (!bluetoothPermission.isGranted) {
      await Permission.bluetooth.request();
    }

    var scanPermission = await Permission.bluetoothScan.status;
    print('Bluetooth Scan Permission Status: $scanPermission');
    if (!scanPermission.isGranted) {
      await Permission.bluetoothScan.request();
    }

    var connectPermission = await Permission.bluetoothConnect.status;
    print('Bluetooth Connect Permission Status: $connectPermission');
    if (!connectPermission.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    // Now check the Bluetooth adapter state
    var aState = await FlutterBluePlus.adapterState.first;
    print("aState: $aState");
    var isOn = (aState == BluetoothAdapterState.on);
    print("Controller isOn: $isOn");

    //true = on (ask to Scan)
    //false = off (ask to turn on)
    return isOn;
  }

  Future<bool> askBluetoothPermission(bool isOn) async {
    print("Permission: $isOn");
    //if bluetooth is off
    if (!isOn) {
      //prompt user to turn on bluetooth
      await FlutterBluePlus.turnOn();

      //if bluetooth is on
      if (isOn) {
        await scanDevices();
      }
    }
    //if bluetooth is on
    else {
      await scanDevices();
    }
    return isOn;
  }

  Future<void> scanDevices() async {
    var subscription = FlutterBluePlus.scanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          print(
              '${r.device.remoteId}: "${r.advertisementData.advName}" found!\n');
        }
      },
      onError: (e) => print(e),
    );

    try {
      print("================================================================");
      print("\t\t\t\t\t\tSTARTING SCAN");
      print("================================================================");
      await FlutterBluePlus.startScan();

      //Wait for 5s before executing the following codes
      await Future.delayed(Duration(seconds: 2));

      print("================================================================");
      print("\t\t\t\t\t\tSTOPPING SCAN");
      print("================================================================");

      //Scan will automatically stop if you put a timeout attribute in it
      //this stopScan() will ensure bluetooth will not scan longer than 5s
      FlutterBluePlus.stopScan();

      FlutterBluePlus.cancelWhenScanComplete(subscription);
    } catch (e) {
      print("BLUETOOTH ERROR: $e");
    }
  }

  StreamSubscription<BluetoothConnectionState> bluetoothConnectState(
      BluetoothDevice device) {
    var subscription =
        device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // await BluetoothController().scanDevices();
        print(
            "Global Device is Disconnected: ${device.disconnectReason?.code} ${device.disconnectReason?.description}\n");
        // Navigator.pop(context);
      }
    });

    return subscription;
  }
}

//Scan Feature converted into a callable function

class BluetoothSavedDevicesHandler {
  // Function to display a dialog for device connection confirmation
  // Future<void> confirmConnectionDialog(
  //     BuildContext context, String mac, String pfname) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(pfname),
  //       content: Text("Connect to this device?"),
  //       actions: [
  //         //No Option
  //         MaterialButton(
  //           color: Colors.lightBlue,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text("No"),
  //         ),
  //         SizedBox(width: 60),
  //         //Yes Option
  //         MaterialButton(
  //           color: Colors.lightBlue,
  //           onPressed: () async {
  //             navigateToProfileIfConnected(context, mac);
  //             Navigator.pop(context);
  //           },
  //           child: Text("Yes", style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // Function to navigate to profile under certain conditions
  // void navigateToProfileIfConnected(BuildContext context, String mac) async {
  //   //determine if the current device is connected
  //   //through our mac address
  //   bool isConnected = connectedDevices.any(
  //     (device) => device.remoteId.toString() == mac,
  //   );

  //   //if we're already connected, then we go to the profile
  //   if (isConnected) {
  //     print("Already Connected");
  //     Navigator.of(context).pushNamed(
  //       deviceprofile,
  //       arguments: PairArguments(
  //         connectedDevices[0],
  //         connectedDevices[0].platformName,
  //         connectedDevices[0].remoteId.toString(),
  //       ),
  //     );
  //   }
  //   //if we're not... then we're searching the results
  //   else {
  //     //try to find our mac address in the recent scan
  //     //if it returns false, we don't have to waste time searching for it
  //     bool isInTheScanResult = results.any(
  //       (device) => device.device.remoteId.toString() == mac,
  //     );
  //     print("ScanResult: $isInTheScanResult");
  //     if (isInTheScanResult) {
  //       for (var result in results) {
  //         print("Device: ${result.device.remoteId.toString()} // Local: $mac");
  //         if (result.device.remoteId.toString() == mac) {
  //           BluetoothDevice foundDevice = result.device;
  //           await foundDevice.connect();
  //           if (foundDevice.isConnected) {
  //             Navigator.of(context).pushNamed(
  //               deviceprofile,
  //               arguments: PairArguments(
  //                 foundDevice,
  //                 foundDevice.platformName,
  //                 foundDevice.remoteId.toString(),
  //               ),
  //             );
  //           }
  //         }
  //       }
  //     } else {
  //       print("Found Nothing");
  //       return;
  //     }
  //   }
  // }
}

//It's Vital, I don't know what this does, but it's important...
class OnBluetoothValueReceived extends StatefulWidget {
  const OnBluetoothValueReceived({super.key, required this.characteristic});
  final BluetoothCharacteristic characteristic;

  @override
  State<OnBluetoothValueReceived> createState() =>
      _OnBluetoothValueReceivedState();
}

class _OnBluetoothValueReceivedState extends State<OnBluetoothValueReceived> {
  String? notifiedData;

  @override
  void initState() {
    // TODO: implement initState
    _initializeBLEDataListener();
    super.initState();
  }

  void _initializeBLEDataListener() async {
    // Enable notifications for the characteristic
    await widget.characteristic.setNotifyValue(true);

    // Listen for incoming data
    widget.characteristic.onValueReceived.listen((value) {
      if (value.isNotEmpty) {
        // Update the data received, here assuming it's an integer for example
        int receivedInt = value[0];
        setState(() {
          notifiedData = "Received integer: $receivedInt";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(notifiedData.toString());
  }
}
