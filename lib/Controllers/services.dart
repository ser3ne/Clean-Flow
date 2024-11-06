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
  bool isAnAlertActive = false;
  Future<Stream<List<int>>?> getCharacteristicStream(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    // Find the specific service
    final service = services.firstWhere(
      (s) => s.uuid.toString() == "beb5483e-36e1-4688-b7f5-ea07361b26a8",
    );

    if (service != null) {
      // Find the specific characteristic
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
      );

      // Enable notifications
      await characteristic.setNotifyValue(true);

      // Return the stream of characteristic values
      return characteristic.onValueReceived;
    } else {
      print("Service or characteristic not found");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<List<int>>?>(
      future: getCharacteristicStream(widget.device),
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
          ));
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

            // Convert the list of bytes to a string and parse to an integer
            String receivedString = utf8.decode(dataSnapshot.data!);
            int receivedValue = int.tryParse(receivedString) ?? 0;

            // Check if the value exceeds 50 and display an alert if so
            if (receivedValue > 300 && !isAnAlertActive) {
              isAnAlertActive = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Alert"),
                      content: Text(
                        "Received value exceeded 50: $receivedValue",
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            isAnAlertActive = false;
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              });
            }

            // Display the received data in the widget
            return Center(
              child: Text(
                "Received data: $receivedValue",
                style: TextStyle(fontSize: 24),
              ),
            );
          },
        );
      },
    );
  }
}
