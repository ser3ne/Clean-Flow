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
  int localMonth = 0;

  List<FlSpot> test = [
    FlSpot(2, 228),
    FlSpot(13, 233),
  ];

  List<FlSpot> highList = [];

  FlSpot high = FlSpot(0, 0);
  FlSpot localHigh = FlSpot(0, 0);

  FlSpot low = FlSpot(0, 0);
  FlSpot localLow = FlSpot(0, 0);

  void getLowValues(day, low) async {
    debugPrint("CHART: Low $low");
    String xString = day.toString();
    String lowYString = low.toString();

    double x = double.parse(xString);
    double lowY = double.parse(lowYString);

    if (x.isFinite && lowY.isFinite) {
      debugPrint(
          "NOT infinite: Day: ($x ${x.runtimeType})\tHigh: ($lowY ${lowY.runtimeType})");
    } else if (!x.isNaN && !lowY.isNaN) {
      debugPrint(
          "NOT NaN: Day: ($x ${x.runtimeType})\tHigh: ($lowY ${lowY.runtimeType})");
    } else {
      debugPrint("x, lowY, and highY is infinite");
    }

    setState(() {
      localLow = FlSpot(x, lowY);
    });
  }

  void getHighValues(day, high, months) {
    debugPrint("CHART: High $high");
    //Convert to String so that when we can cleanly convert to double
    String mString = months.toString();
    String xString = day.toString();
    String highYString = high.toString();

    double x = double.parse(xString);
    double highY = double.parse(highYString);

    //these are for indexing months and days

    //checkking if the values happen to be infinite
    //plano ko gawing try/catch pero meh...
    if ((x.isFinite && highY.isFinite) && (!x.isNaN && !highY.isNaN)) {
      debugPrint(
          "NOT infinite/NaN: Day: ($x ${x.runtimeType})\tHigh: ($highY ${highY.runtimeType})");
    } else {
      debugPrint("x, lowY, and highY is infinite");
    }

    setState(() {
      localDay = int.parse(xString);
      localMonth = int.parse(mString);
      debugPrint("Month:Day: $localMonth:$day");
      localHigh = FlSpot(x, highY);
    });
  }

  final List<String> monthNames = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        // decoration: BoxDecoration(border: Border.all(width: 1)),
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width - 100,
        child: LineChart(
          LineChartData(
              lineBarsData: [
                //High
                // [
                //   ...widget.dnt.map(
                //     (data) {
                //       getHighValues(data['day'], data['high'], data['month']);
                //       return localHigh;
                //     },
                //   )
                // ]
                LineChartBarData(
                  spots: [],
                  isCurved: widget.isCurved,
                  barWidth: widget.barWidth,
                  color: widget.highColor,
                ),
                //Low
                // [
                //       ...widget.dnt.map(
                //         (data) {
                //           getLowValues(data['day'], data['low']);
                //           return localLow;
                //         },
                //       )
                //     ]
                LineChartBarData(
                    spots: test,
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
                    debugPrint("Current DAY: $localDay");
                    debugPrint("Value/Meta: $value/$meta");

                    final FlSpot match = test.firstWhere(
                      (spot) => spot.x == value,
                      orElse: () => FlSpot.nullSpot,
                    );

                    if (match.x != null) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 12));
                    }
                    return const SizedBox.shrink();

                    // if (value <= 7 && value > 0) {
                    //   return Text("1");
                    // } else if (value <= 14) {
                    //   return Text("2");
                    // } else if (value <= 21) {
                    //   return Text("3");
                    // } else if (value <= 28) {
                    //   return Text("4");
                    // }
                    // return Text("5");
                  },
                )),
              )),
        ),
      ),
    );
  }
}
