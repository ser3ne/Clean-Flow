// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:capstone/Controllers/bluetooth_controller.dart';
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
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.12,
      child: FloatingActionButton(
        onPressed: () {
          //put code here...
          //initatie new Scan for new devices
          print("tapped: ${widget.deviceMac}, ${widget.platformName}");
          BluetoothSavedDevicesHandler().confirmConnectionDialog(
              context, widget.deviceMac, widget.platformName);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.platformName,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isConnected
                        ? Icons.bookmark_added_rounded
                        : Icons.bookmark_remove_outlined,
                    size: 30,
                  )
                ],
              ),
              Switch(
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
            ],
          ),
        ),
      ),
    );
  }
}
