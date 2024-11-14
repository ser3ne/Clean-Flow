// ignore_for_file: prefer_const_constructors

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
      await characteristic.setNotifyValue(true);

      // Return the stream of characteristic values
      return characteristic.onValueReceived;
    } catch (e) {
      //snackbar
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
            String receivedData = String.fromCharCodes(dataSnapshot.data!);
            List<String> values = receivedData.split(',');
            List<String> voltTemp = values[0].split('.');
            List<String> reducTemp = values[1].split('.');

            // Parse each part as an integer
            String volts = voltTemp[0];
            String percentageReduction = reducTemp[0];

            // Display both values in the widget
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .06,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.5,
                        color: const Color.fromARGB(255, 23, 53, 24),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: const Color.fromARGB(255, 132, 255, 136),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "$volts V",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    width: MediaQuery.of(context).size.width * .7,
                    height: MediaQuery.of(context).size.height * .06,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.5,
                        color: Color.fromARGB(255, 22, 45, 84),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "$percentageReduction% Reduction",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
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
