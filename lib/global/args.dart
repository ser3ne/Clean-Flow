import 'package:flutter_blue_plus/flutter_blue_plus.dart';

BluetoothDevice? globalDevice;
String absoluteFilePath = "";
List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
BluetoothCharacteristic? characteristic;

bool globalBoolean = false;

class PairArguments {
  final BluetoothDevice device;
  final double size;

  PairArguments(this.device, this.size);
}

class ConnectedArguments {
  final BluetoothDevice device;
  ConnectedArguments(this.device);
}
