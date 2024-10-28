// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceProfiles extends StatefulWidget {
  const DeviceProfiles({
    super.key,
  });

  @override
  State<DeviceProfiles> createState() => _DeviceProfilesState();
}

class _DeviceProfilesState extends State<DeviceProfiles> {
  bool isSwitch = false;
  BluetoothDevice? device;

  void setUp(PairArguments args) {
    setState(() {
      device = args.device;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PairArguments;
    setUp(args);
    print("device: ${args.device}");
    String deviceName = device!.platformName.toString();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(deviceName),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Text("Connect to device?"),
                  Switch(
                      value: isSwitch,
                      onChanged: (bool value) async {
                        setState(() {
                          isSwitch = value;
                        });

                        var subscription = device!.connectionState
                            .listen((BluetoothConnectionState state) async {
                          if (state == BluetoothConnectionState.disconnected) {
                            print(
                                "Global Device is Disconnected: ${device!.disconnectReason?.code} ${device!.disconnectReason?.description}");
                            Navigator.pop(context);
                          }
                        });

                        if (isSwitch == true) {
                          device!.cancelWhenDisconnected(subscription,
                              delayed: true, next: true);
                          await device!.connect();
                          subscription.cancel();
                          await Future.delayed(Duration(milliseconds: 1300));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Connected to Device a Successfully")));

                          PairArguments pairArguments = PairArguments(device!);
                          Navigator.pop(context, pairArguments);
                        }
                      }),
                ],
              ),
            )));
  }
}
