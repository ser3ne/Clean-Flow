import 'package:flutter_blue_plus/flutter_blue_plus.dart';

String absoluteFilePath = "";
List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
List<dynamic> savedDevices = [];
List<ScanResult> results = [];
bool globalBoolean = false;

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
