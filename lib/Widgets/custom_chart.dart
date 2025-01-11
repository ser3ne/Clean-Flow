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
  int day = 0, month = 0;
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
    day = int.parse(xString);
    month = int.parse(mString);

    //checkking if the values happen to be infinite
    //plano ko gawing try/catch pero meh...
    if ((x.isFinite && highY.isFinite) && (!x.isNaN && !highY.isNaN)) {
      debugPrint(
          "NOT infinite/NaN: Day: ($x ${x.runtimeType})\tHigh: ($highY ${highY.runtimeType})");
    } else {
      debugPrint("x, lowY, and highY is infinite");
    }
    setState(() {
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
    return SizedBox(
      height: 260,
      width: 480,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              //High
              LineChartBarData(
                  spots: [
                    ...widget.dnt.map(
                      (data) {
                        getHighValues(data['day'], data['high'], data['month']);

                        return localHigh;
                      },
                    )
                  ],
                  isCurved: widget.isCurved,
                  barWidth: widget.barWidth,
                  color: widget.highColor),
              //Low
              LineChartBarData(
                  spots: [
                    ...widget.dnt.map(
                      (data) {
                        getLowValues(data['day'], data['low']);

                        return localLow;
                      },
                    )
                  ],
                  isCurved: widget.isCurved,
                  barWidth: widget.barWidth,
                  color: widget.lowColor)
            ],
            titlesData: FlTitlesData(
                topTitles: AxisTitles(
                    axisNameWidget: Text(
                      monthNames[month],
                    ),
                    sideTitles: const SideTitles(
                      showTitles: false,
                    )),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                    axisNameWidget: const Text("WEEKS"),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (day < 8 && day > 0) {
                          return const Text("WEEK 1");
                        } else if (day < 15) {
                          return const Text("WEEK 2");
                        } else if (day < 22) {
                          return const Text("WEEK 3");
                        } else if (day < 29) {
                          return const Text("WEEK 4");
                        } else {
                          return const Text("WEEK 5");
                        }
                      },
                    )))),
      ),
    );
  }
}
