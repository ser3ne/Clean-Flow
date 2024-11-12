// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEDataDisplay extends StatefulWidget {
  const BLEDataDisplay({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<BLEDataDisplay> createState() => _BLEDataDisplayState();
}

class _BLEDataDisplayState extends State<BLEDataDisplay> {
  Future<Stream<List<int>>?> getCharacteristicStream() async {
    // Discover services on the device
    List<BluetoothService> services = await widget.device.discoverServices();

    try {
      // Find the specific service
      final service = services.firstWhere(
        (s) => s.uuid.toString() == "beb5483e-36e1-4688-b7f5-ea07361b26a8",
      );

      // Find the specific characteristic
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
      );

      // Enable notifications
      await characteristic
          .setNotifyValue(false); //set this to true to start receiving data

      // Return the stream of characteristic values
      return characteristic.onValueReceived;
    } catch (e) {
      print("Service or characteristic not found");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<List<int>>?>(
      future: getCharacteristicStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "No Data Transmitted",
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Use StreamBuilder to listen to the characteristic's data stream
        return StreamBuilder<List<int>>(
          stream: snapshot.data!,
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Waiting for data..."));
            } else if (dataSnapshot.hasError) {
              return Center(child: Text("Error receiving data"));
            } else if (!dataSnapshot.hasData || dataSnapshot.data!.isEmpty) {
              return Center(child: Text("No data received"));
            }

            // Convert the list of bytes to a string
            String receivedString = utf8.decode(dataSnapshot.data!);

            // Split the string into two parts based on the comma separator
            List<String> values = receivedString.split(',');

            // Parse each part as an integer
            int increment1 = int.tryParse(values[0]) ?? 0;
            int increment2 = int.tryParse(values[1]) ?? 0;

            // Display both values in the widget
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Increment 1: $increment1",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "Increment 2: $increment2",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
