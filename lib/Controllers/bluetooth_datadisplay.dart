// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'package:capstone/Widgets/custom_switchbutton.dart';
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
  final double _frequency = .05; // Frequency of the sine wave
  final int _maxPoints = 100; // Number of points to show on the chart

  List<dynamic> historicalData = [];
  List<FlSpot> _cleanSpots = [];
  List<FlSpot> _noisySpots =
      []; //this is the lists we fill values for the chart
  List<FlSpot> _voltSpots = []; //this is the lists we fill values for the chart

  double _currentX = 0.1; // Relative x-value for the sine wave
  double amplitude = 200; // Height of the sine wave
  double maxYVal = 0.0;
  double minYVal = 0.0;

  bool isConnected = false;
  bool haveAlerted = false;
  List<int> _high = [];
  List<int> voltList = [];
  List<int> perc = [];
  int percentReduction = 0;
  int intVoltage = 0;
  int high = 0;
  int low = 0;

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

  Future<bool> acknowledge(double voltage) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: double.infinity,
          height: 65,
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.red),
          child: Center(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 50,
            ),
          ),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    widget.device.platformName,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    " has detected high amounts of fluctuations.\nreadings at the time was: ${voltage}V",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context); //closes the pop-up
                },
                child: Text("Got it")),
          )
          //No
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Stream<List<int>>?>(
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
                } else if (!dataSnapshot.hasData ||
                    dataSnapshot.data!.isEmpty) {
                  return Center(child: Text("No data received"));
                }
                String receivedData = String.fromCharCodes(dataSnapshot.data!);
                List<String> values = receivedData.split(',');
                List<String> voltTemp = values[0].split('.');
                List<String> reducTemp = values[1].split('.');
                List<String> cleanTemp = values[2].split('.');
                List<String> noiseTemp = values[3].split('.');

                String voltsStr = voltTemp[0].trim();
                String percentageReductionStr = reducTemp[0].trim();
                String cleanStr = cleanTemp[0].trim();
                String noiseStr = noiseTemp[0].trim();

                percentReduction = int.parse(percentageReductionStr);
                perc.add(percentReduction);
                // Parse as an integer
                if (voltsStr.isNotEmpty && voltsStr.startsWith('-')) {
                  voltsStr = voltsStr.substring(1);
                }
                if (noiseStr.isNotEmpty && noiseStr.startsWith('-')) {
                  noiseStr = noiseStr.substring(1);
                }
                if (cleanStr.isNotEmpty && cleanStr.startsWith('-')) {
                  cleanStr = cleanStr.substring(1);
                }
                double doubleVoltage = double.parse(voltsStr);
                double noise = double.parse(noiseStr);
                double clean = double.parse(cleanStr);
                intVoltage = doubleVoltage.toInt();

                _high.add(doubleVoltage.toInt());
                voltList.add(doubleVoltage.toInt());
                if (_high.length > 100) {
                  _high.remove(0);
                }
                int highRaw = _high.reduce(
                    (value, element) => value > element ? value : element);
                int lowRaw = _high.reduce(
                    (value, element) => value < element ? value : element);
                if (high < highRaw) {
                  high = highRaw;
                }
                if (low > (0 - lowRaw)) {
                  low = lowRaw;
                }
                //call the function here
                debugPrint(
                    "Noise: $noise\t||\tVolt: $doubleVoltage\t||\tReduction: $percentageReductionStr\t||\tClean: $clean");

                if (doubleVoltage >= 240) {
                  if (!haveAlerted) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        haveAlerted = true;
                        acknowledge(doubleVoltage);
                      },
                    );
                  }
                }

                // Calculate the new y-value for the sine wave
                // i think it's the _amplitude we change for values we want to see
                double voltY = doubleVoltage * sin(_frequency * _currentX);
                double noiseY = noise * sin(_frequency * _currentX) - 4;
                double cleanY = clean * sin(_frequency * _currentX) + 6;

                // Add the new point to the sine wave
                _voltSpots.add(FlSpot(_currentX, voltY));
                _noisySpots.add(FlSpot(_currentX, noiseY));
                _cleanSpots.add(FlSpot(_currentX, cleanY));

                // Remove the oldest point if we exceed the maximum points allowed
                if (_voltSpots.length > _maxPoints) {
                  _voltSpots.removeAt(0);
                }
                if (_noisySpots.length > _maxPoints) {
                  _noisySpots.removeAt(0);
                }
                if (_cleanSpots.length > _maxPoints) {
                  _cleanSpots.removeAt(0);
                }

                //get the max and min value to dynamically change the chart
                FlSpot maxYValRaw = _voltSpots.reduce(
                    (value, element) => value.y > element.y ? value : element);
                FlSpot minYValRaw = _voltSpots.reduce(
                    (value, element) => value.y < element.y ? value : element);

                if (maxYVal < maxYValRaw.y) {
                  maxYVal = maxYValRaw.y; //assign the maxY
                }
                if (minYVal > minYValRaw.y) {
                  minYVal = minYValRaw.y; //assign the minY
                }

                // Increment the _currentX value for the next point
                //change the wavelength
                _currentX += 3;

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
                            //constant

                            //Clean Electricity
                            LineChartBarData(
                              spots: _cleanSpots,
                              isCurved: false,
                              barWidth: 2,
                              belowBarData: BarAreaData(
                                  show: false,
                                  color:
                                      const Color.fromARGB(96, 68, 137, 255)),
                              dotData: FlDotData(show: false),
                              color: Color.fromARGB(255, 0, 255, 42),
                            ),

                            //Noise / EMI
                            LineChartBarData(
                              spots: _noisySpots,
                              isCurved: false,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                  show: false,
                                  color: const Color.fromARGB(96, 255, 82, 82)),
                              dotData: FlDotData(show: false),
                              color: const Color.fromARGB(255, 255, 17, 0),
                            ),

                            //Voltage
                            LineChartBarData(
                              spots: _voltSpots,
                              isCurved: false,
                              barWidth: 2,
                              belowBarData: BarAreaData(
                                  show: false,
                                  color:
                                      const Color.fromARGB(96, 68, 137, 255)),
                              dotData: FlDotData(show: false),
                              color: Color.fromARGB(255, 195, 255, 0),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Highest:",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  children: [
                                TextSpan(
                                    text: " ${high}",
                                    style: TextStyle(
                                        color: high > 240
                                            ? Colors.red
                                            : Colors.black))
                              ])),
                          RichText(
                              text: TextSpan(
                                  text: "Lowest:",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  children: [
                                TextSpan(
                                    text: " ${low}",
                                    style: TextStyle(
                                        color: (low) <= 180
                                            ? Colors.red
                                            : Colors.black))
                              ])),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        //volts
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
                              "${voltsStr}V",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        //Noise
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .06,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.5,
                              color: Color.fromARGB(255, 53, 23, 23),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color.fromARGB(255, 211, 50, 50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "$noiseStr Noise",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        )
                      ],
                    ),
                    //Reducton
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .06,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.5,
                          color: Color.fromARGB(255, 22, 45, 84),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        color: Colors.yellow,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "$percentageReductionStr%Reduction",
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
        ),
        SizedBox(
          height: 45,
        ),
        //Custom Disconnect Switch
        SizedBox(
          height: MediaQuery.of(context).size.height * .1, //10%
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  setState(() {
                    voltList;
                    _high;
                    perc;
                  });
                },
              );
            },
            child: CustomSwitchButtonBig(
                device: widget.device,
                dialogueText:
                    isConnected ? "Are You Sure?" : "Disconnect Device",
                size: 55,
                high: _high,
                voltage: voltList,
                percentReduction: perc),
          ),
        )
      ],
    );
  }
}
