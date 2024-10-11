// ignore_for_file: avoid_print, prefer_const_constructors, collection_methods_unrelated_type

import 'package:capstone/homepage/homepage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController {
  //This tells the app to target all ESP32 with this service uuid
  Guid targetServiceUUID = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  Future<void> scanDevices() async {
    try {
      print(
          "==================================================================================================================================");
      print("\t\t\t\t\t\tSTARTING SCAN");
      print(
          "==================================================================================================================================");
      FlutterBluePlus.startScan();

      // //Wait for 5s before executing the following codes
      await Future.delayed(Duration(seconds: 1));

      print(
          "==================================================================================================================================");
      print("\t\t\t\t\t\tSTOPPING SCAN");
      print(
          "==================================================================================================================================");

      //Scan will automatically stop if you put a timeout attribute in it
      //this stopScan() will ensure bluetooth will not scan longer than 5s
      FlutterBluePlus.stopScan();
    } catch (e) {
      print("BLUETOOTH ERROR: $e");
    }
  }
}
