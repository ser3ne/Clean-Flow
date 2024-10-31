// ignore_for_file: prefer_const_constructors

import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceOverview extends StatefulWidget {
  final BluetoothDevice device;
  final String platformName;
  const DeviceOverview(
      {super.key, required this.device, required this.platformName});

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color.fromARGB(146, 196, 196, 196)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Title(
                    color: Colors.black,
                    child: Text(
                      widget.platformName,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ))),
            Expanded(
                flex: 5, child: Text("put more information here\nLorem Ipsum")),
            Expanded(
                flex: 1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 20,
                  child: Switch(
                    value: isConnected,
                    onChanged: (value) {
                      setState(() {
                        //starts as active, then press to de-activate
                        isConnected = value;
                      });
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
