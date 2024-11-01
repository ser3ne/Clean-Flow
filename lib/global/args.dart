import 'package:flutter_blue_plus/flutter_blue_plus.dart';

BluetoothDevice? globalDevice;
String absoluteFilePath = "";
List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
bool globalBoolean = false;

class PairArguments {
  final BluetoothDevice device;
  PairArguments(this.device);
}

class ConnectedArguments {
  final BluetoothDevice device;
  ConnectedArguments(this.device);
}
