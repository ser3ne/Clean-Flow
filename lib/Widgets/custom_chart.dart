import 'package:capstone/Widgets/dummy.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {
  const CustomChart(
      {super.key,
      required this.high,
      required this.highColor,
      required this.low,
      required this.lowColor,
      required this.isCurved,
      required this.barWidth,
      required this.month});
  final List<FlSpot> high, low;
  final Color highColor, lowColor;
  final bool isCurved;
  final double barWidth;
  final int month;

  @override
  Widget build(BuildContext context) {
    List<String> monthNames = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];

    return LineChart(LineChartData(
      lineBarsData: [
        //High
        LineChartBarData(
            spots: high,
            isCurved: isCurved,
            barWidth: barWidth,
            color: highColor),
        //Low
        LineChartBarData(
            spots: low, isCurved: isCurved, barWidth: barWidth, color: lowColor)
      ],
      titlesData:
          LineTitles.getTitleData("${monthNames[month - 1]} Week $month"),
    ));
  }
}
