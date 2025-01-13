// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatefulWidget {
  const CustomChart(
      {super.key,
      required this.highColor,
      required this.lowColor,
      required this.isCurved,
      required this.barWidth,
      required this.name,
      required this.dnt});
  final Color highColor, lowColor;
  final bool isCurved;
  final double barWidth;
  final String name;
  final List<dynamic> dnt;

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  int localDay = 0;
  bool isLoading = true;
  // int localMonth = 0;

  List<FlSpot> highList = [];
  List<FlSpot> lowList = [];

  // List<FlSpot> testHigh = [
  //   FlSpot(11, 210),
  //   FlSpot(12, 250),
  //   FlSpot(16, 250),
  //   FlSpot(17, 250),
  //   FlSpot(19, 250),
  //   FlSpot(31, 100),
  // ];

  // List<FlSpot> testLow = [
  //   FlSpot(11, 220),
  //   FlSpot(12, 244),
  //   FlSpot(16, 250),
  //   FlSpot(17, 250),
  //   FlSpot(31, 100),
  // ];

  Future<void> getLowValues(day, low) async {
    //Convert to String so that when we can cleanly convert to double
    String xString = day.toString();
    String lowYString = low.toString();

    double x = double.parse(xString);
    double lowY = double.parse(lowYString);

    setState(() {
      lowList.add(FlSpot(x, lowY));
    });
    debugPrint("lowList: $lowList");
  }

  Future<void> getHighValues(day, high) async {
    //Convert to String so that when we can cleanly convert to double
    String xString = day.toString();
    String highYString = high.toString();

    double x = double.parse(xString);
    double highY = double.parse(highYString);

    setState(() {
      highList.add(FlSpot(x, highY));
    });
    debugPrint("HighList: $highList");
  }

  Future<void> _processData() async {
    for (var e in widget.dnt) {
      await getHighValues(e['day'], e['high']);
      await getLowValues(e['day'], e['low']);
    }
  }

  @override
  void initState() {
    super.initState();
    _processData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        // decoration: BoxDecoration(border: Border.all(width: 1)),
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width - 100,
        child: LineChart(
          LineChartData(
              //High
              lineBarsData: [
                LineChartBarData(
                  spots: highList,
                  isCurved: widget.isCurved,
                  barWidth: widget.barWidth,
                  color: widget.highColor,
                ),
                //Low
                LineChartBarData(
                    spots: lowList,
                    isCurved: widget.isCurved,
                    barWidth: widget.barWidth,
                    color: widget.lowColor)
              ],
              maxY: 260,
              minY: 160,
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                    sideTitles: const SideTitles(
                  showTitles: false,
                )),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Check if the current value matches any x value in dataPoints

                          final roundedValue =
                              double.parse(value.toStringAsFixed(2));

                          final Set<double> lowHigh = {
                            ...highList.map(
                              (e) => e.x,
                            ),
                            ...lowList.map(
                              (e) => e.x,
                            )
                          };

                          debugPrint("VALUES1| lowHigh: $lowHigh");
                          debugPrint("VALUES1| value: $value");
                          if (lowHigh.contains(roundedValue)) {
                            return Text(roundedValue.toInt().toString(),
                                style: const TextStyle(fontSize: 12));
                          }

                          // Return empty for non-matching ticks
                          return const SizedBox.shrink();
                        })),
              )),
        ),
      ),
    );
  }
}
