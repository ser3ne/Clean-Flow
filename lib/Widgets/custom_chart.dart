// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomChart extends StatefulWidget {
  const CustomChart(
      {super.key,
      required this.highColor,
      required this.lowColor,
      required this.isCurved,
      required this.barWidth,
      required this.name});
  final Color highColor, lowColor;
  final bool isCurved;
  final double barWidth;
  final String name;

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
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
  int voltHigh = 0, voltLow = 0, day = 0, month = 0;
  List<FlSpot> _high = [];
  List<FlSpot> _low = [];
  List<dynamic> historicalData = [];
  List<dynamic> filteredData = [];

  Future<void> _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('historicalData');
    if (jsonString != null) {
      setState(() {
        historicalData = jsonDecode(jsonString);
        _filterData();
      });
    }
  }

  void _filterData() {
    setState(() {
      filteredData =
          historicalData.where((data) => data['name'] == widget.name).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadHistoricalData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filteredData.map((data) {
        // voltHigh = data['high'];
        // voltLow = data['low'];
        day = data['day'];
        month = data['month'];
        _high.add(FlSpot(day.toDouble(), data['high']));
        _low.add(FlSpot(day.toDouble(), data['low']));
      });
      // _high.add(FlSpot(day.toDouble(), voltHigh.toDouble()));
      // _low.add(FlSpot(day.toDouble(), voltLow.toDouble()));
    });
    print("HIGH: $_high\nLOW: $_low\nDAY: $day\nMONTH: $month");
    return LineChart(
      LineChartData(
          lineBarsData: [
            //High
            LineChartBarData(
                spots: _high,
                isCurved: widget.isCurved,
                barWidth: widget.barWidth,
                color: widget.highColor),
            //Low
            LineChartBarData(
                spots: _low,
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
                          return const Text("1");
                        } else if (day < 15) {
                          return const Text("2");
                        } else if (day < 22) {
                          return const Text("3");
                        } else if (day < 29) {
                          return const Text("4");
                        } else {
                          return const Text("5");
                        }
                      })))),
    );
  }
}
