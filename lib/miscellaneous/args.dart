import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceArguments {
  final BluetoothDevice device;
  final String deviceName;

  DeviceArguments(this.device, this.deviceName);
}
