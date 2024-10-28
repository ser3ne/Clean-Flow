import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PairArguments {
  final BluetoothDevice device;
  PairArguments(this.device);
}

class ConnectedArguments {
  final BluetoothDevice device;
  ConnectedArguments(this.device);
}
