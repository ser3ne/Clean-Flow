// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/Controllers/bluetooth_scan.dart';
import 'package:flutter/material.dart';

class DeviceOverview extends StatefulWidget {
  const DeviceOverview({
    super.key,
    required this.deviceMac,
    required this.platformName,
  });

  final String platformName;
  final String deviceMac;

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.3,
      child: FloatingActionButton(
        onPressed: () async {
          //put code here...
          await BluetoothController().scanDevices();
          BluetoothScan(mac: widget.deviceMac);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      widget.platformName,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      isConnected
                          ? Icons.bookmark_added_rounded
                          : Icons.bookmark_remove_outlined,
                      size: 50,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Switch(
                  inactiveTrackColor: Colors.white,
                  activeTrackColor: Colors.blueAccent,
                  inactiveThumbColor: Colors.black,
                  value: isConnected,
                  onChanged: (value) {
                    setState(() {
                      isConnected = value;
                    });
                  },
                ),
              ),
              Expanded(flex: 3, child: Text(""))
            ],
          ),
        ),
      ),
    );
  }
}
