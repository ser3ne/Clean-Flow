// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DeviceOverview extends StatefulWidget {
  const DeviceOverview({super.key});

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        color: Colors.orange,
      ),
    );
  }
}
