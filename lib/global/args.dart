import 'package:flutter_blue_plus/flutter_blue_plus.dart';

BluetoothDevice? globalDevice;
String absoluteFilePath = "";
List<BluetoothDevice> savedDevices = FlutterBluePlus.connectedDevices;

class PairArguments {
  final BluetoothDevice device;
  PairArguments(this.device);
}

class ConnectedArguments {
  final BluetoothDevice device;
  ConnectedArguments(this.device);
}
