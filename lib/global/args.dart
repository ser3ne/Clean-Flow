import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

BluetoothDevice? globalDevice;
bool globalBoolean = false;
List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
List<dynamic> savedDevices = [];

List<BluetoothDevice> copyResult = [];

const Color colorY = Color.fromRGBO(13, 255, 0, 0.871);
const Color colorX = Color.fromRGBO(2, 4, 140, 0.788);

class PairArguments {
  final BluetoothDevice device;
  final String pfName;
  final String macAddress;

  PairArguments(this.device, this.pfName, this.macAddress);
}

class HistoricalArguments {
  final String deviceName;
  HistoricalArguments(this.deviceName);
}

class shit {
  final String id, mac, year, month, day, hour, minute, perc, voltag, high, low;
  shit(this.id, this.mac, this.year, this.month, this.day, this.hour,
      this.minute, this.perc, this.voltag, this.high, this.low);
}
