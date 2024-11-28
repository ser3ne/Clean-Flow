// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEDataDisplay extends StatefulWidget {
  const BLEDataDisplay({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<BLEDataDisplay> createState() => _BLEDataDisplayState();
}

class _BLEDataDisplayState extends State<BLEDataDisplay> {
  List<FlSpot> _percentReducSpots =
      []; //this is the lists we fill values for the chart
  List<FlSpot> _voltSpots = []; //this is the lists we fill values for the chart
  double _currentX = 0.1; // Relative x-value for the sine wave
  double amplitude = 200; // Height of the sine wave
  final double _frequency = .05; // Frequency of the sine wave
  final int _maxPoints = 20; // Number of points to show on the chart
  double maxYVal = 0.0;
  double minYVal = 0.0;
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
  void initState() {
    // TODO: implement initState
    super.initState();
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

            String volts = voltTemp[0];
            String percentageReduction = reducTemp[0];
            // Parse as an integer
            double voltage = double.parse(volts);
            double doubleReduc = double.parse(percentageReduction);

            // if (voltage >= 240) {
            //   showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //       titlePadding: EdgeInsets.zero,
            //       title: Container(
            //         width: double.infinity,
            //         height: 65,
            //         // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(25),
            //                 topRight: Radius.circular(25)),
            //             color: Colors.red),
            //         child: Center(
            //           child: Icon(
            //             Icons.warning_amber_rounded,
            //             size: 50,
            //           ),
            //         ),
            //       ),
            //       content: SizedBox(
            //         height: 150,
            //         child: Column(
            //           children: [
            //             Expanded(
            //               flex: 3,
            //               child: Center(
            //                 child: Text(
            //                   widget.device.platformName,
            //                   softWrap: true,
            //                   textAlign: TextAlign.center,
            //                   // overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.w600, fontSize: 25),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 3,
            //               child: Center(
            //                 child: Text(
            //                   " has detected high amounts of fluctuations.\nreadings at the time was: ${voltage}V",
            //                   softWrap: true,
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.w400, fontSize: 15),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       actions: [
            //         Center(
            //           child: MaterialButton(
            //               color: Colors.lightBlue,
            //               onPressed: () {
            //                 Navigator.pop(context); //closes the pop-up
            //               },
            //               child: Text("Got it")),
            //         )
            //         //No
            //       ],
            //     ),
            //   );
            // }

            // Calculate the new y-value for the sine wave
            // i think it's the _amplitude we change for values we want to see
            double voltY = voltage * sin(_frequency * _currentX);
            double percentReducY = doubleReduc * sin(_frequency * _currentX);

            // Add the new point to the sine wave
            _voltSpots.add(FlSpot(_currentX, voltY));
            _percentReducSpots.add(FlSpot(_currentX, percentReducY));

            // Remove the oldest point if we exceed the maximum points allowed
            if (_voltSpots.length > _maxPoints) {
              _voltSpots.removeAt(0);
            }
            if (_percentReducSpots.length > _maxPoints) {
              _percentReducSpots.removeAt(0);
            }
            FlSpot maxYValRaw = _voltSpots.reduce(
                (value, element) => value.y > element.y ? value : element);
            FlSpot minYValRaw = _voltSpots.reduce(
                (value, element) => value.y < element.y ? value : element);

            if (maxYVal < maxYValRaw.y) {
              maxYVal = maxYValRaw.y;
            }
            if (minYVal > minYValRaw.y) {
              minYVal = minYValRaw.y;
            }

            // Increment the current x-value for the next point
            //change the wavelength
            // _currentX += 1.029;
            _currentX += 100;

            // Display both values in the widget
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Sine Wave Chart
                Container(
                  height: 250,
                  child: LineChart(
                    // this object is the chart
                    LineChartData(
                      //this list is where you put LineChartBarData() to make multiple data sets
                      lineBarsData: [
                        // Spots is what we refer to as points, where users can hover and see
                        // the data in that position
                        LineChartBarData(
                          spots: _voltSpots,
                          isCurved: false,
                          barWidth: 2,
                          belowBarData: BarAreaData(
                              show: false,
                              color: const Color.fromARGB(96, 68, 137, 255)),
                          dotData: FlDotData(show: false),
                          color: Colors.green,
                        ),
                        LineChartBarData(
                          spots: _percentReducSpots,
                          isCurved: false,
                          barWidth: 2,
                          belowBarData: BarAreaData(
                              show: false,
                              color: const Color.fromARGB(96, 255, 82, 82)),
                          dotData: FlDotData(show: false),
                          color: Colors.blue,
                        )
                      ],
                      // minX: _currentX - _maxPoints.toDouble(),
                      maxY: maxYVal,
                      minY: minYVal,

                      //horizontal and vertical labels of values
                      titlesData: const FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 60))),
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
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
            );
          },
        );
      },
    );
  }
}
