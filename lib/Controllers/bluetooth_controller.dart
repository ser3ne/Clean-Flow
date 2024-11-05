// ignore_for_file: avoid_print, prefer_const_constructors, collection_methods_unrelated_type

import 'dart:async';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController {
  //This tells the app to target all ESP32 with this service uuid
  Guid targetServiceUUID = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");

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
      await Future.delayed(Duration(seconds: 1));

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

  StreamSubscription<BluetoothConnectionState> bluetoothConnectState() {
    var subscription = globalDevice!.connectionState
        .listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // await BluetoothController().scanDevices();
        print(
            "Global Device is Disconnected: ${globalDevice!.disconnectReason?.code} ${globalDevice!.disconnectReason?.description}\n");
        // Navigator.pop(context);
      }
    });

    return subscription;
  }
}

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
