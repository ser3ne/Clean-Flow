import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

bool globalBoolean = false;
String absoluteFilePath = "";
List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
List<dynamic> savedDevices = [];
List<BluetoothDevice> copyResult = [];

const Color colorY = Color.fromARGB(222, 13, 255, 0);
const Color colorX = Color.fromARGB(201, 2, 4, 140);

class PairArguments {
  final BluetoothDevice device;
  final String pfName;
  final String macAddress;

  PairArguments(this.device, this.pfName, this.macAddress);
}

class ScanArguments {
  final String mac;
  ScanArguments(this.mac);
}
