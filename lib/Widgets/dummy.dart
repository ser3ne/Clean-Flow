// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dummy extends StatelessWidget {
  const Dummy({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    String indexStr = index.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Data $indexStr", textAlign: TextAlign.center),
      ],
    );
  }
}

class LineTitles {
  static const monthNames = [
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

  static getTitleData(String title) => FlTitlesData(
      topTitles: AxisTitles(
          axisNameWidget: Center(
              child: Text(
            title,
          )),
          sideTitles: SideTitles(
            showTitles: false,
          )),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                DateTime now = DateTime.now();

                return Text("${now.day}");
              })));
}
