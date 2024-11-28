import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DynamicSineWave extends StatefulWidget {
  const DynamicSineWave(
      {super.key, required this.volt, required this.area, required this.reduc});

  final double volt, reduc;
  final bool area;

  @override
  _DynamicSineWaveState createState() => _DynamicSineWaveState();
}

class _DynamicSineWaveState extends State<DynamicSineWave> {
  List<FlSpot> _percentReducSpots =
      []; //this is the lists we fill values for the chart
  List<FlSpot> _voltSpots = []; //this is the lists we fill values for the chart
  double _currentX = 0.0; // Relative x-value for the sine wave
  late Timer _timer; // Timer to periodically update the chart
  double amplitude = 200; // Height of the sine wave
  final double _frequency = .05; // Frequency of the sine wave
  final int _maxPoints = 100; // Number of points to show on the chart

  @override
  void initState() {
    super.initState();
    //initializing variables

    _percentReducSpots = [FlSpot(_currentX, amplitude)];
    _voltSpots = [FlSpot(_currentX, amplitude)];
    // _redSpots = [FlSpot(_currentX, amplitude)];
    // Start a periodic timer to update the sine wave
    //change the ms to change how fast the chart updates
    setState(() {
      _updateSineWave(widget.reduc, widget.volt);
    });
  }

//debugPrint("X: $_currentX\t|| Y: $blueY");
  void _updateSineWave(double reduc, double volts) {
    // Calculate the new y-value for the sine wave
    // i think it's the _amplitude we change for values we want to see
    double voltY = volts * sin(_frequency * _currentX);
    double percentReducY = reduc * sin(_frequency * _currentX);
    // double redY = 2 * amplitude - (blueY);

    //logs the values
    debugPrint("X: $_currentX\t|| Y: $voltY");
    // Add the new point to the sine wave
    _voltSpots.add(FlSpot(_currentX, voltY));
    _percentReducSpots.add(FlSpot(_currentX, percentReducY));
    // _redSpots.add(FlSpot(_currentX, redY));

    // Remove the oldest point if we exceed the maximum points allowed
    if (_voltSpots.length > _maxPoints) {
      _voltSpots.removeAt(0);
    }
    if (_percentReducSpots.length > _maxPoints) {
      _percentReducSpots.removeAt(0);
    }

    // Increment the current x-value for the next point
    //change the wavelength
    _currentX += 1.029;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          //initialize the chart
          LineChart(
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
                  show: widget.area,
                  color: const Color.fromARGB(96, 68, 137, 255)),
              dotData: FlDotData(show: false),
              color: Colors.green,
            ),
            LineChartBarData(
              spots: _percentReducSpots,
              isCurved: false,
              barWidth: 2,
              belowBarData: BarAreaData(
                  show: widget.area,
                  color: const Color.fromARGB(96, 255, 82, 82)),
              dotData: FlDotData(show: false),
              color: Colors.blue,
            )
          ],
          // minX: _currentX - _maxPoints.toDouble(),
          // maxX: _currentX,
          maxY: widget.volt,
          minY: (0 - widget.volt),

          //horizontal and vertical labels of values
          titlesData: const FlTitlesData(
              show: true,
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 60))),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }
}
